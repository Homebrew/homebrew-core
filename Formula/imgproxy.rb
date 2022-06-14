class Imgproxy < Formula
  desc "Fast and secure server for resizing and converting remote images"
  homepage "https://imgproxy.net"
  url "https://github.com/imgproxy/imgproxy/archive/v3.6.0.tar.gz"
  sha256 "eb98d90313379a09d0d7421a1f0f9c0b42439d75f21bd746b2bcbb607caf65a6"
  license "MIT"
  head "https://github.com/imgproxy/imgproxy.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "049fe74403c708285388147ef8555907ae64c4b03c2f77476cb925aca2998fa6"
    sha256 cellar: :any,                 arm64_big_sur:  "c42d065fe58819dc3108bbd3ea55ddeedaa7bbc99bd85fa82f30144c9b079691"
    sha256 cellar: :any,                 monterey:       "814c3ce37c3d5a66f60a16ff41e51defd515ae0cf0452b745034b89b952784ec"
    sha256 cellar: :any,                 big_sur:        "d4a48151cc5325af9b59052553f083d543c6a8bed94934f9e53a82f3f4558646"
    sha256 cellar: :any,                 catalina:       "4d5016e594a91578b2b107c4ebe98f3c846b1314f77bfb0dd1bd15d0605911d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc3df1ecebb8f3eaf1bd6b046493905fb8c05893b82bf1b507fb1a0620ec18f3"
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
