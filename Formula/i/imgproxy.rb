class Imgproxy < Formula
  desc "Fast and secure server for resizing and converting remote images"
  homepage "https://imgproxy.net"
  url "https://github.com/imgproxy/imgproxy/archive/v3.18.2.tar.gz"
  sha256 "b65a4df906a76716136fc4b4fd744cec83da6589992dd52f48de2b3f8eee4a2b"
  license "MIT"
  head "https://github.com/imgproxy/imgproxy.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ee64eeb07dde664b337fd81b265b56c868f8f7c0256f55117a87a2392fc0e6c8"
    sha256 cellar: :any,                 arm64_monterey: "ed60da6cac8f055ac7560b4bed51f17deaa33a7c3092c3a780733762b921d03f"
    sha256 cellar: :any,                 arm64_big_sur:  "d6f96cbc9cb67cedf2f3c2d23dc9d2e7bc097548cb36cc1cb905ed73d97b0216"
    sha256 cellar: :any,                 ventura:        "dcf6067df1db88aa61fc960f0107e467e14f6b57b21bf656906a6ee832212db6"
    sha256 cellar: :any,                 monterey:       "4be9c0a79c89705f882e3a1cea5d8a41ce1b92da5d27e52e8a8db4e476fc55f8"
    sha256 cellar: :any,                 big_sur:        "f10f366e64ba074cb39c4b47a471883d78210a793b944fa7bc70b0257d60f3ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d28d46d0e4d5d538ee915eb462ccb7082b2a197bc0f9318d501c5124c3c0fe62"
  end

  depends_on "go" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
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
    sleep 20

    output = testpath/"test-converted.png"

    system "curl", "-s", "-o", output,
           "http://127.0.0.1:#{port}/insecure/resize:fit:100:100:true/plain/local:///test.jpg@png"
    assert_predicate output, :exist?

    file_output = shell_output("file #{output}")
    assert_match "PNG image data", file_output
    assert_match "100 x 100", file_output
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
