class Imgproxy < Formula
  desc "Fast and secure server for resizing and converting remote images"
  homepage "https://imgproxy.net"
  url "https://github.com/imgproxy/imgproxy/archive/refs/tags/v4.0.24.tar.gz"
  sha256 "55fb080f48ff4c83a27bebe8c47099565484ea631f61bf8cb6de81d4826917d3"
  license "Apache-2.0"
  head "https://github.com/imgproxy/imgproxy.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "42f65b2342a4bfacdfdf9bf68e1b0159bbe10a57a30d8b021962de08d95c9f36"
    sha256 cellar: :any, arm64_tahoe:       "469e603be1cebb091d4832e4d9672e6ff567364ab51fc4d6e8ee042fa0d3aecc"
    sha256 cellar: :any, arm64_sequoia:     "4078b7d5f17b9baa452572687de4ae6be157036c30c0c561c79f5e49f9052e81"
    sha256 cellar: :any, arm64_linux:       "45f1445e0ce09311b5900f7b3cc054ec6003ede46cdd14ac6452cc1f85848f2d"
    sha256 cellar: :any, x86_64_linux:      "426360edc973475873cee69262b0845ec1ad6e8cb008e8ff1c81ffbe018dbd2a"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build
  depends_on "glib"
  depends_on "vips"

  on_macos do
    depends_on "gettext"
  end

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_LDFLAGS_ALLOW"] = "-s|-w"
    ENV["CGO_CFLAGS_ALLOW"] = "-Xpreprocessor"

    # Workaround to avoid patchelf corruption when cgo is required
    if OS.linux? && Hardware::CPU.arm64?
      ENV["CGO_ENABLED"] = "1"
      ENV["GO_EXTLINK_ENABLED"] = "1"
      ENV.append "GOFLAGS", "-buildmode=pie"
    end

    system "go", "build", *std_go_args, "./cli"
  end

  test do
    port = free_port
    cp test_fixtures("test.jpg"), testpath/"test.jpg"

    ENV["IMGPROXY_BIND"] = "127.0.0.1:#{port}"
    ENV["IMGPROXY_LOCAL_FILESYSTEM_ROOT"] = testpath

    pid = spawn bin/"imgproxy"
    sleep 20

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
