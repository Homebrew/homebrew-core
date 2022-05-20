class Imgproxy < Formula
  desc "Fast and secure server for resizing and converting remote images"
  homepage "https://imgproxy.net"
  url "https://github.com/imgproxy/imgproxy/archive/v3.5.0.tar.gz"
  sha256 "8880dc4c1e16a4480effa3de85a339010820f6f262bf8a307a3325b679453e2b"
  license "MIT"
  head "https://github.com/imgproxy/imgproxy.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "0bcdc8434e1ce889004de35c282f3966d6a854dd00e8051f7f0df03a5375dbfa"
    sha256 cellar: :any,                 arm64_big_sur:  "6586a72c5d9ab7f82c1d024b34e7c73f5b000f82afe6889ca3d5b1f2dea8a210"
    sha256 cellar: :any,                 monterey:       "dbdc6c3a3b68bd61eb52b6377754d38960a290f1fba0bb3aeddc143482f1cfce"
    sha256 cellar: :any,                 big_sur:        "882030b3f872fdf85a8acacab20eeb42036aca5dfb52236b8ac0b1561d940d95"
    sha256 cellar: :any,                 catalina:       "1434a22b04e82150d000329e019000773624528fb6ebad55be862537837a4621"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b5212c5ac0e14784d05faf2b866ff4a906cbfee6f49398017fa96df1131a63ab"
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
    sleep 10

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
