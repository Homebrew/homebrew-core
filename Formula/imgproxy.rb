class Imgproxy < Formula
  desc "Fast and secure server for resizing and converting remote images"
  homepage "https://imgproxy.net"
  url "https://github.com/imgproxy/imgproxy/archive/v2.8.2.tar.gz"
  sha256 "5b7d17b9b4f2423c52d18ffac28ba554b3df48785132555758e9cd8e5024650c"
  head "https://github.com/imgproxy/imgproxy.git"

  bottle do
    cellar :any
    sha256 "8907a8c19dfe60bd2fe68b49e2ab7fcddea60f00403196cb006a597afc9cd67a" => :catalina
    sha256 "ee13514b1c297ba7d9adfe22ca702ed166638cc9f6f203875f5a127bfc1b401d" => :mojave
    sha256 "04eef493086bc7dec61f8d27f1477e16dea730659f2375fd2f101ad5b505e9db" => :high_sierra
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
