class Imgproxy < Formula
  desc "Fast and secure server for resizing and converting remote images"
  homepage "https://imgproxy.net"
  url "https://github.com/imgproxy/imgproxy/archive/v2.7.0.tar.gz"
  sha256 "9a97a4b184f67718f97a4b3d16cd98b61a825ba418e6e04139ed3a3a9d787fad"
  head "https://github.com/imgproxy/imgproxy.git"

  bottle do
    cellar :any
    sha256 "e8a745e2febcc0e27306dbd4c1d9b1215c744cbc0900cf75c9c83dda41fa0a95" => :catalina
    sha256 "d987ba0ad66e8927fce68f881f4a3d6415ec92a2718716eaac35926a0011a735" => :mojave
    sha256 "e1cd7887d771e625d128d120e90c8a2d5b14877668d712a18e56839c3fe692eb" => :high_sierra
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
