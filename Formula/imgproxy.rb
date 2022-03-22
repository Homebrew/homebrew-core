class Imgproxy < Formula
  desc "Fast and secure server for resizing and converting remote images"
  homepage "https://imgproxy.net"
  url "https://github.com/imgproxy/imgproxy/archive/v3.3.3.tar.gz"
  sha256 "a322608d1c6a32d5e0e3fffe03be4856a6245bf73fca9b24dd5f4265a836648c"
  license "MIT"
  head "https://github.com/imgproxy/imgproxy.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "8b8903136a5eb849327ee42fbff249c1641f28d7241fb17e854fd114af7c8947"
    sha256 cellar: :any,                 arm64_big_sur:  "4e5057bded09ca524740eeed7b19528da9de1b526580dfb6a882373052cb952a"
    sha256 cellar: :any,                 monterey:       "063fd6523cd08a434963c0619b5335aa447b19ce04fefe306dbd252c8bd06af3"
    sha256 cellar: :any,                 big_sur:        "5684b577fc8141aa0601263079117403f25d2b90b756b78ac5cfc57396f9e1fa"
    sha256 cellar: :any,                 catalina:       "dcc75e7051033c7a8602dafd7ab94758a7babccba5fa3bbe83a7f3bcda5ef5c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a31d739cf2f3fcd7282ca9fe8f346947ba8efd2cb48f2a01ed7c0a6f9bf7db8"
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
