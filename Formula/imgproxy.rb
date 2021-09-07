class Imgproxy < Formula
  desc "Fast and secure server for resizing and converting remote images"
  homepage "https://imgproxy.net"
  url "https://github.com/imgproxy/imgproxy/archive/v2.17.0.tar.gz"
  sha256 "f04486e02ca40d14e65cf1774c7bad85d5a237de3798b14cc1160e9eafdb8200"
  license "MIT"
  head "https://github.com/imgproxy/imgproxy.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "ec7baaa49e8e557f3caec444dc89cd728d9b3a954b293a93f20582fdc48340fb"
    sha256 cellar: :any, big_sur:       "267e63891e7efe226cfcacd5efc557497392d53b2a0d0f51d1bbc9f4f18adad5"
    sha256 cellar: :any, catalina:      "3776427cf853631d1fe9167745eb872dd03804d7546701a153f86f0fe776e689"
    sha256 cellar: :any, mojave:        "b3bf3f5ebbee3badecd323cbfb24d6b6bf363057515bfab312250c99aedd1af7"
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
