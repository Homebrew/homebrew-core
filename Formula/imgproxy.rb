class Imgproxy < Formula
  desc "Fast and secure server for resizing and converting remote images"
  homepage "https://imgproxy.net"
  url "https://github.com/imgproxy/imgproxy/archive/v3.16.0.tar.gz"
  sha256 "44a06428f37a271852738bcdbb8d8cdb662cf5ee23876b1aca1c61872ad10f87"
  license "MIT"
  head "https://github.com/imgproxy/imgproxy.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "10f174d1b4a05a742ecd2baea02abafc0edb0524a06b8f533cfaef3efec8a772"
    sha256 cellar: :any,                 arm64_monterey: "a92078716ab7cc014081c6efa84c5c9a832dbcb957ed2588b84536f6964442fb"
    sha256 cellar: :any,                 arm64_big_sur:  "77ee40defbca3918b95aff28a5efea34b2e05f2f56c1d9671b1e034a8f62018e"
    sha256 cellar: :any,                 ventura:        "ba2917c12dcdf19136a91cb937df4a0fcfe6875bd60feea03bb9a2d495d0d725"
    sha256 cellar: :any,                 monterey:       "e64b59c0d5feacaa48012dfaf77407fc6901b81a435462bf65555adf1c3e13ec"
    sha256 cellar: :any,                 big_sur:        "24e9606c0bf3aa567a6d42cfe209def45d0a2dc83a8a349bd0c6854f7d9202c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bcda7d22199a7e6bb2cfcec47a1749492ef724e7d2b23bfd954dad572af7d432"
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
