class Imgproxy < Formula
  desc "Fast and secure server for resizing and converting remote images"
  homepage "https://imgproxy.net"
  url "https://github.com/imgproxy/imgproxy/archive/v2.10.1.tar.gz"
  sha256 "3d9458dff70f6ca7dec54996aad7115ffdb0315323814a3a942f773f770b7bc9"
  head "https://github.com/imgproxy/imgproxy.git"

  bottle do
    cellar :any
    sha256 "00ccc578f8e285ea971dfb62b89c42f8a47ed889c64ced5f0e8560812ab0c339" => :catalina
    sha256 "5d8239fa9fdf86460c52eebd7c23df2b94a227c3311bdd21c6d81e98c6ce5d58" => :mojave
    sha256 "e5b06fe37914f6a412f5c324c3d69649320abf53893d69f35c8b5f296e790a8b" => :high_sierra
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
