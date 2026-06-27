class Imgproxy < Formula
  desc "Fast and secure server for resizing and converting remote images"
  homepage "https://imgproxy.net"
  url "https://github.com/imgproxy/imgproxy/archive/refs/tags/v4.0.7.tar.gz"
  sha256 "a3a22422ceaf133559c54630e102adb10ea51775fcb594f11a15a8a6cfc02f69"
  license "Apache-2.0"
  head "https://github.com/imgproxy/imgproxy.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "b525b91461e2a9f34d2323cc764b0fa9cc4756b16ccfea9c387954f831b95287"
    sha256 cellar: :any, arm64_sequoia: "b7ef579686f49d34536ad428ff8cb79d9e6e9e14cc6881fc088f7bb84ed2e6a4"
    sha256 cellar: :any, arm64_sonoma:  "f23bfca38de8800fb3d711b86e24933a196d93065490a699ed481d1df1791510"
    sha256 cellar: :any, sonoma:        "0fdc30525000847ff57d62271a14ce27dae24fb59309e2460562d6a3351b7e13"
    sha256 cellar: :any, arm64_linux:   "ab9e3e7ebc26f2dc30bfb3f03e808af733e1d445a2189ca154c67287cd46fbe8"
    sha256 cellar: :any, x86_64_linux:  "27b7eba11faa192cfe0ffef9609668ec3fa631ef75d4855eea94ee4566093007"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build
  depends_on "glib"
  depends_on "vips"

  on_macos do
    depends_on "gettext"
  end

  def install
    ENV["CGO_LDFLAGS_ALLOW"] = "-s|-w"
    ENV["CGO_CFLAGS_ALLOW"] = "-Xpreprocessor"

    # Workaround to avoid patchelf corruption when cgo is required
    if OS.linux? && Hardware::CPU.arch == :arm64
      ENV["CGO_ENABLED"] = "1"
      ENV["GO_EXTLINK_ENABLED"] = "1"
      ENV.append "GOFLAGS", "-buildmode=pie"
    end

    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cli"
  end

  test do
    port = free_port
    cp test_fixtures("test.jpg"), testpath/"test.jpg"

    ENV["IMGPROXY_BIND"] = "127.0.0.1:#{port}"
    ENV["IMGPROXY_LOCAL_FILESYSTEM_ROOT"] = testpath

    pid = spawn bin/"imgproxy"
    sleep 20
    sleep 50 if OS.mac? && Hardware::CPU.intel?

    output = testpath/"test-converted.png"
    url = "http://127.0.0.1:#{port}/insecure/resize:fit:100:100:true/plain/local:///test.jpg@png"

    system "curl", "-s", "-o", output, url
    assert_path_exists output

    file_output = shell_output("file #{output}")
    assert_match "PNG image data", file_output
    assert_match "100 x 100", file_output
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
