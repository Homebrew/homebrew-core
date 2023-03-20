class Imgproxy < Formula
  desc "Fast and secure server for resizing and converting remote images"
  homepage "https://imgproxy.net"
  url "https://github.com/imgproxy/imgproxy/archive/v3.14.0.tar.gz"
  sha256 "b7cba8fa6dc1bf0ec5c5ab0b791877bbe9037cc474657c2bd8c7d2ab21fa220e"
  license "MIT"
  head "https://github.com/imgproxy/imgproxy.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "023ffaeee304f7e371deab0bd751b0166b45a4e754ce7f46f0b6ca462c4c4aea"
    sha256 cellar: :any,                 arm64_monterey: "5b2894ab02349a681d4a50e7764aa639ec5ed52a401d055cf89fa1d2ac2562ae"
    sha256 cellar: :any,                 arm64_big_sur:  "38e969d2e5508a33a7c51237a831f39e8f46a6bc7dd33425c1bbc0bd911ba2d9"
    sha256 cellar: :any,                 ventura:        "fa2f60ecef8469ccdaa39eb52b6dbff6ef9ba5889f2dc68821477b537fb372ad"
    sha256 cellar: :any,                 monterey:       "37e26bde9033916321dee998c40e48ac8366d73f61d032ce6c4ed8b193ac983c"
    sha256 cellar: :any,                 big_sur:        "2290f430f8f772bac1890df529116283c12ef173bf90dbcad162f1898675fdc0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "308606ea34cd0af87ff2532e32103c7f656fa9052044845eb5044505aa3afb8d"
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
