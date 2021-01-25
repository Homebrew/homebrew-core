class Imgproxy < Formula
  desc "Fast and secure server for resizing and converting remote images"
  homepage "https://imgproxy.net"
  url "https://github.com/imgproxy/imgproxy/archive/v2.15.0.tar.gz"
  sha256 "3bee2aecbb66c98c9e1254a163fb53e32e8af5bf8e3a92f119427113bee01c91"
  license "MIT"
  revision 1
  head "https://github.com/imgproxy/imgproxy.git"

  bottle do
    cellar :any
    sha256 "ccd0a102ec452a68a26280f0173534784d0a7797de833bafbc2015027634fc0a" => :big_sur
    sha256 "215159ed8fcf0216e0f81cb38c460316349828680d5376358c21ba6ee77138b2" => :arm64_big_sur
    sha256 "8cefa46ab480ea6b763077f8d12b0783e9482355aa2b1bf99ee2c8126279f8c6" => :catalina
    sha256 "ca7688ab9b51b8f6e71d664bd210ccacefd66c08f16fce12fd26b89b8017358e" => :mojave
    sha256 "7572ce24b608a282fc82231c0d2455f03dcc15953df73de4f302bf11375fb39c" => :high_sierra
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
