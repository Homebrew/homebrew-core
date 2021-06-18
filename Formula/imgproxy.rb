class Imgproxy < Formula
  desc "Fast and secure server for resizing and converting remote images"
  homepage "https://imgproxy.net"
  url "https://github.com/imgproxy/imgproxy/archive/v2.16.4.tar.gz"
  sha256 "28dcc116b029df27532c631beb1c85810695561c34465caa36b2c62eda601aa1"
  license "MIT"
  head "https://github.com/imgproxy/imgproxy.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "dd28ec015ee149bf8a9820ec5d895c275720728725de7ea5e54fffd951063f66"
    sha256 cellar: :any, big_sur:       "ceea462bfb922aa853612bafc80f1a07d37159f0abbd62a8e4cd8b447f59c144"
    sha256 cellar: :any, catalina:      "9b7b437300a03c903c0764f6590a337ff24d975d6f80a0d20bd4f6c74ad89581"
    sha256 cellar: :any, mojave:        "593fa5dfe2eaa7ba481b19ab41a8cfc2467139b92b1dffdcb8dd9607f6ce656d"
  end

  depends_on "go" => :build
  depends_on "pkg-config" => :build
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
           "http://127.0.0.1:#{port}/insecure/fit/100/100/no/0/plain/local:///test.jpg@png"
    assert_equal 0, $CHILD_STATUS
    assert_predicate output, :exist?

    file_output = shell_output("file #{output}")
    assert_match "PNG image data", file_output
    assert_match "1 x 1", file_output
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
