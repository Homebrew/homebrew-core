class Imgproxy < Formula
  desc "Fast and secure server for resizing and converting remote images"
  homepage "https://imgproxy.net"
  url "https://github.com/imgproxy/imgproxy/archive/v2.8.0.tar.gz"
  sha256 "ce5d5317e4db0fe5ca611458ab417943f6054bbc04dab93f61fc0071f6500996"
  head "https://github.com/imgproxy/imgproxy.git"

  bottle do
    cellar :any
    sha256 "710cdc91a8839ffc147dc32ed46b606ad69a1aa4f2270f8c74542e8d2668a034" => :catalina
    sha256 "4e6860e5c8cd0f3322a39f1e9566780ba1f4aa0763b55f63e7137348038d5b04" => :mojave
    sha256 "59c41dbd0cd2c7b4acc50ea328e13423778739ab8697818d29a1048dcb606999" => :high_sierra
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

    system("curl", "-s", "-o", output, "http://127.0.0.1:#{port}/insecure/fit/100/100/no/0/plain/local:///test.jpg@png")
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
