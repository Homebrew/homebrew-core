class Imgproxy < Formula
  desc "Fast and secure server for resizing and converting remote images"
  homepage "https://imgproxy.net"
  url "https://github.com/imgproxy/imgproxy/archive/v2.13.1.tar.gz"
  sha256 "1a65fd8579e9a9f6a393d4d768f517e48e090707a11cc02bb46153e26ac0c833"
  license "MIT"
  revision 1
  head "https://github.com/imgproxy/imgproxy.git"

  bottle do
    cellar :any
    sha256 "1d689272611de42065d737bc031d2bad4b1b0218e753e1291a194f476ebd4323" => :catalina
    sha256 "a250050aa34ac48c89246349cee3321f3e6bdfa2ee89d6f03a21997df33cb394" => :mojave
    sha256 "b817b2307645cb4148b64575fe99630f7a5b197ca4b28ac217a855fc79aa5ebf" => :high_sierra
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
    port = free_port

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
