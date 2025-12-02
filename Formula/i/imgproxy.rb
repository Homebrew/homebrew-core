class Imgproxy < Formula
  desc "Fast and secure server for resizing and converting remote images"
  homepage "https://imgproxy.net"
  url "https://github.com/imgproxy/imgproxy/archive/refs/tags/v3.30.1.tar.gz"
  sha256 "c2c81f18775ccf0dc0c4cb03aafe39bc8a893ec3e4a533a3f33eaaf1bcc7fdf1"
  license "MIT"
  head "https://github.com/imgproxy/imgproxy.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "af03e1c2fb83394a349325a5ae4e58c25d9cef7174b532e904a90ce16e57819f"
    sha256 cellar: :any,                 arm64_sequoia: "1682d02e84955e52224d37dcd2fe4a9e0caeee24bd06f9a60bfeb53f938c99a9"
    sha256 cellar: :any,                 arm64_sonoma:  "1a6b1b7ab05c113e2d88757ca429714ae43ceeebbf0f58df7fd1d1946b416554"
    sha256 cellar: :any,                 sonoma:        "cb7b326929e752d3f57024eb2c7d481aa4cbfe70b9b57ffbbd276800a48c947d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7a6c33c5d5c946971a406771854168b10fccb4d834a4c0296eeeeff10a0f20f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9838b42cefbaedca10d093e8ccc29c63a789b10fc092f0a8a2d6193eb58a5191"
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

    system "go", "build", *std_go_args(ldflags: "-s -w")
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
