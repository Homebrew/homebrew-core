class Imgproxy < Formula
  desc "Fast and secure server for resizing and converting remote images"
  homepage "https://imgproxy.net"
  url "https://github.com/imgproxy/imgproxy/archive/v2.16.7.tar.gz"
  sha256 "a86c60134fc06999c2bf038e0f12d73dd7452125764bf127b8adafc31db5426a"
  license "MIT"
  head "https://github.com/imgproxy/imgproxy.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "2dfb2c3c09c3ee7b09134193a81a77679464288a9caba134daf898c72dcd1607"
    sha256 cellar: :any, big_sur:       "5d2cf693a61cda0d7f5872a6e9153a59d63ac32d31ebd60c0c8e9f17951b743f"
    sha256 cellar: :any, catalina:      "a2fb0440d896aa92b03e0a5486f72dedee54179847f8d89ef6c9e510513816db"
    sha256 cellar: :any, mojave:        "a5f66e7d9c3bfc7876ad7fc2266bb856cc2310500bb97219b0188d2551234926"
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
