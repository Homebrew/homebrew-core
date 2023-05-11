class Imgproxy < Formula
  desc "Fast and secure server for resizing and converting remote images"
  homepage "https://imgproxy.net"
  url "https://github.com/imgproxy/imgproxy/archive/v3.17.0.tar.gz"
  sha256 "050f0a0cf072b4dadd63fe5f421d29cfd3e80dbbf83df24deacd2dc3ec1ff86b"
  license "MIT"
  head "https://github.com/imgproxy/imgproxy.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "323887ce7f4e2568b746edca52cfb018a9d7d53474e2fa801e57fc712616992f"
    sha256 cellar: :any,                 arm64_monterey: "52c91d779511d7b63033d028cf08b03125b95d708d327e1c1aafaf043dec5d4d"
    sha256 cellar: :any,                 arm64_big_sur:  "6c265dd9205de1e1abeff9f43a96b1679ae33dc9caa49758a14baf85f7af5ad9"
    sha256 cellar: :any,                 ventura:        "55f6aca8c23f126f8dab448cce2300335d730a838454c995bcac5cdc3d4b5a5e"
    sha256 cellar: :any,                 monterey:       "e8c05c7f30541fe5f59246b164fbe25e7beee4f24b0544288520c7b5d0e4c3f1"
    sha256 cellar: :any,                 big_sur:        "1b94669aa9cdd0e1524987931820fc9f6f21fe7e11ccba4809f4b274ce9c7b43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a0863ba8a6a2cc0f3ef37eb34966775a7918f6714358a1918e85b3dfc5bbe500"
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
