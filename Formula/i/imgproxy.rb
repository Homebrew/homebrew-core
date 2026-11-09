class Imgproxy < Formula
  desc "Fast and secure server for resizing and converting remote images"
  homepage "https://imgproxy.net"
  url "https://github.com/imgproxy/imgproxy/archive/refs/tags/v4.0.23.tar.gz"
  sha256 "a10829246d3e67679f728c8b1cafe3e5516333ade4d733fcf2e3610d8432f3af"
  license "Apache-2.0"
  head "https://github.com/imgproxy/imgproxy.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "aa72643d11ad1fa927e9f9cfeea5e6770641e5c6dd2d7a8da96ac5a0248234ac"
    sha256 cellar: :any, arm64_tahoe:       "11c62c7ea556313017d2266f24c1cf4ea0f79733cacca65a8e6cade14fe7dfb0"
    sha256 cellar: :any, arm64_sequoia:     "c79c78aeecda1fc59dfc26e9122c317508058b13474dbb978022fa2f24a7fe04"
    sha256 cellar: :any, arm64_linux:       "3186284afb0596f7d7e60964ed6b36f3feb3c69bf9382eabe5ae9c2921e8cd2b"
    sha256 cellar: :any, x86_64_linux:      "df32205b0ef0fc2ec6aed6117a78ab080913445606efb424831353862628b6e1"
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
