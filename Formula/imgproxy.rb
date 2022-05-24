class Imgproxy < Formula
  desc "Fast and secure server for resizing and converting remote images"
  homepage "https://imgproxy.net"
  url "https://github.com/imgproxy/imgproxy/archive/v3.5.1.tar.gz"
  sha256 "1ad4f38c56db422bef77289a17653189776fc50f7749cb0e938e539fabb57830"
  license "MIT"
  head "https://github.com/imgproxy/imgproxy.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "e7acbc701b3ae53e2c3b5051eb0cb6c03fdd97d08a5d2133e151cc2ebfea4114"
    sha256 cellar: :any,                 arm64_big_sur:  "ef29d612775f2e525bb4ee6dc1a910589baae6499e6df425903035e0a66b824e"
    sha256 cellar: :any,                 monterey:       "1e32b714dcde4f59eeb632a3d01692512c403f63fbf8d22899b56be380df7650"
    sha256 cellar: :any,                 big_sur:        "296328c50fa01dfd195743ee2ec371192f98079272fe8644add7d55dd155ece8"
    sha256 cellar: :any,                 catalina:       "44babcf7260fc1747c5a0a4ea57cf9b712c6baade9194a3ff52abaf03c8c7577"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "792980775879ab6b7f0bd7d00a8456a67706f52e42b832065294bee96b123179"
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
