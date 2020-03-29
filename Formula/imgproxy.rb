class Imgproxy < Formula
  desc "Fast and secure server for resizing and converting remote images"
  homepage "https://imgproxy.net"
  url "https://github.com/imgproxy/imgproxy/archive/v2.11.0.tar.gz"
  sha256 "5de08bdfb180da030a8a342eed5ed29e031aef6d9ac7f10e5df94cec2ac42a5c"
  head "https://github.com/imgproxy/imgproxy.git"

  bottle do
    cellar :any
    sha256 "d7cd051833518b69c6b65cf88e92e03e4a268b82408d1828768a6b69c7de9e59" => :catalina
    sha256 "1f5b0d985f1a2999efb2f0ccfabc785b38c6542363795f6be57627e91f2fed14" => :mojave
    sha256 "4d1e8046cd60db5a8a12bf897e6680bc75ef656bffa8c153c507ddd26681e115" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "pkg-config" => :build
  depends_on "vips"

  def install
    ENV["CGO_LDFLAGS_ALLOW"]="-s|-w"
    ENV["CGO_CFLAGS_ALLOW"]="-Xpreprocessor"

    system "go", "build", "-o", "#{bin}/#{name}"
  end

  test do
    require "socket"

    server = TCPServer.new(0)
    port = server.addr[1]
    server.close

    cp(test_fixtures("test.jpg"), testpath/"test.jpg")

    ENV["IMGPROXY_BIND"] = "127.0.0.1:#{port}"
    ENV["IMGPROXY_LOCAL_FILESYSTEM_ROOT"] = testpath

    pid = fork do
      exec bin/"imgproxy"
    end
    sleep 3

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
