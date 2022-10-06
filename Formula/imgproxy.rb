class Imgproxy < Formula
  desc "Fast and secure server for resizing and converting remote images"
  homepage "https://imgproxy.net"
  url "https://github.com/imgproxy/imgproxy/archive/v3.8.0.tar.gz"
  sha256 "811ccca896fbf307eb9526bfa5d991f3be95ddda030d03d14a0eb1a5d2f525c1"
  license "MIT"
  head "https://github.com/imgproxy/imgproxy.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "3d50f21bfb26856bd154051da17f28571dbb206c34b69aded19965f4c1efc3c3"
    sha256 cellar: :any,                 arm64_big_sur:  "3954b34f8f8495e043aaaf93a04ea4cd009467df1df60efabf3a57730fc8b08a"
    sha256 cellar: :any,                 monterey:       "18ae223c477bc7ae41ff7ef556ec97f6aae9f8020cc5117a7ad517e24c8b4d6f"
    sha256 cellar: :any,                 big_sur:        "2b048778844f3944ec199162c6ab74110a5ec477c3cccee6e1407aa5ae69b55e"
    sha256 cellar: :any,                 catalina:       "667b858dcd1e96b030615852934fa5221a422f700bfcb123c96a96dffc6c16ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "20a7c5f70ba84e88337da2c719ceab64945329de77759794e7423c49b2b89187"
  end

  depends_on "go" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "vips"

  def install
    ENV["CGO_LDFLAGS_ALLOW"]="-s|-w"
    ENV["CGO_CFLAGS_ALLOW"]="-Xpreprocessor"

    system "go", "build", *std_go_args
  end

  test do
    port = free_port

    cp(test_fixtures("test.jpg"), testpath/"test.jpg")

    ENV["IMGPROXY_BIND"] = "127.0.0.1:#{port}"
    ENV["IMGPROXY_LOCAL_FILESYSTEM_ROOT"] = testpath

    pid = fork do
      exec bin/"imgproxy"
    end
    sleep 10

    output = testpath/"test-converted.png"

    system "curl", "-s", "-o", output,
           "http://127.0.0.1:#{port}/insecure/resize:fit:100:100:true/plain/local:///test.jpg@png"
    assert_predicate output, :exist?

    file_output = shell_output("file #{output}")
    assert_match "PNG image data", file_output
    assert_match "100 x 100", file_output
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
