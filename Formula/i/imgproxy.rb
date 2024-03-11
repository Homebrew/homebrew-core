class Imgproxy < Formula
  desc "Fast and secure server for resizing and converting remote images"
  homepage "https://imgproxy.net"
  url "https://github.com/imgproxy/imgproxy/archive/refs/tags/v3.23.0.tar.gz"
  sha256 "d48721d96bf2974af4b6e612d0cdb27484d132c9f9ad17abe5c2095f22beeb8d"
  license "MIT"
  head "https://github.com/imgproxy/imgproxy.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "30ca617cca9b5978555fb3d519c0176c4e946e78a6abe85a2b32857474935541"
    sha256 cellar: :any,                 arm64_ventura:  "752ca319c132452e3f7f98f09caf5a9b5e01e90a0b8662870bb2b77ee6dd683e"
    sha256 cellar: :any,                 arm64_monterey: "020522fdb7bde2e46b1104361c1714f523d6e60d45995a07f0dd16364de6bcb9"
    sha256 cellar: :any,                 sonoma:         "c650e23954f6e0a89d4d0e2a72839dba8c910cc38d646aa94f970003bc51b270"
    sha256 cellar: :any,                 ventura:        "56e80f6ee105136ee6817ca253c10e12e293fbf976dd6c0a62dad33037aeb57b"
    sha256 cellar: :any,                 monterey:       "2f6fbf945f71f9c7db121727856a8676b2bf937555b08a85e87af192c1f2ac1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0fd65325ffd4060420684c1c73485fac3ab46985f8116d14e2af3b85859df478"
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
