class Imgproxy < Formula
  desc "Fast and secure server for resizing and converting remote images"
  homepage "https://imgproxy.net"
  url "https://github.com/imgproxy/imgproxy/archive/v2.10.0.tar.gz"
  sha256 "8f773f7719a338234d43d55d207ed04b771cbaf278c6cfdfb755ecd9e611c004"
  head "https://github.com/imgproxy/imgproxy.git"

  bottle do
    cellar :any
    sha256 "13cd9b47056ea9cd41814f5d1ce6e9c89ce080f9c86a537313f14a52cf9bf016" => :catalina
    sha256 "9bc09ef603138ead4694778610d4d207be474575dae1afef41d474ee3fb70f4d" => :mojave
    sha256 "6f740f323d747bd885751e5c85416e92bf48ded35699fca1c5e662d7a91a6249" => :high_sierra
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
