class Imgproxy < Formula
  desc "Fast and secure server for resizing and converting remote images"
  homepage "https://imgproxy.net"
  url "https://github.com/imgproxy/imgproxy/archive/v2.17.0.tar.gz"
  sha256 "f04486e02ca40d14e65cf1774c7bad85d5a237de3798b14cc1160e9eafdb8200"
  license "MIT"
  head "https://github.com/imgproxy/imgproxy.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "9c667257866c86cba040a084a94872b78d225fb4332e3aa9b6406a93d5d8695c"
    sha256 cellar: :any, big_sur:       "e61dc10f8f5c3aec8b874dcfbde017a42b770b38ba69c973f5037b575610de42"
    sha256 cellar: :any, catalina:      "c66c3481a9786623cf31f1126c3e58887096810771be877c89390e4f1f3c2208"
    sha256 cellar: :any, mojave:        "a4b4147457383318bf31c7b5577d03b5bfc200d3f1827e14b0082be27fbdd614"
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
