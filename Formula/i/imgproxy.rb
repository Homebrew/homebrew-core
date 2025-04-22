class Imgproxy < Formula
  desc "Fast and secure server for resizing and converting remote images"
  homepage "https://imgproxy.net"
  url "https://github.com/imgproxy/imgproxy/archive/refs/tags/v3.28.0.tar.gz"
  sha256 "43e1fa6f49b8a0cc82da7e5774342c7b95c74a65381a040cd39acc2c6bf862c6"
  license "MIT"
  head "https://github.com/imgproxy/imgproxy.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "73d5c6d819fbadd507b0282332e110e603076cabc27739df5a7dab59841fb552"
    sha256 cellar: :any,                 arm64_sonoma:  "9412aeb30d70b1a0077a11acf693ee2e75166eb359bc74f92d9ec1cc73b59e8c"
    sha256 cellar: :any,                 arm64_ventura: "93a92638810d263deaa6cb8b9541d5bbf30afe1809835b50caea2b0cedadeda8"
    sha256 cellar: :any,                 sonoma:        "5dee2d3978d48ff30c413dd7f994fac6089fa355fe53886a1f38a4d1c4aa25ef"
    sha256 cellar: :any,                 ventura:       "1abd843a5433c1905ba8686f2e97cda179968e95a20ee69eb35e69349c955086"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "831d008ef5d22a9ada546b9fb83135f7933f1e95992e680e67502355836a7be5"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build
  depends_on "glib"
  depends_on "vips"

  on_macos do
    depends_on "gettext"
  end

  def install
    ENV["CGO_LDFLAGS_ALLOW"] = "-s|-w"
    ENV["CGO_CFLAGS_ALLOW"] = "-Xpreprocessor"

    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    port = free_port
    cp test_fixtures("test.jpg"), testpath/"test.jpg"

    ENV["IMGPROXY_BIND"] = "127.0.0.1:#{port}"
    ENV["IMGPROXY_LOCAL_FILESYSTEM_ROOT"] = testpath

    pid = spawn bin/"imgproxy"
    sleep 20
    sleep 50 if OS.mac? && Hardware::CPU.intel?

    output = testpath/"test-converted.png"
    url = "http://127.0.0.1:#{port}/insecure/resize:fit:100:100:true/plain/local:///test.jpg@png"

    system "curl", "-s", "-o", output, url
    assert_path_exists output

    file_output = shell_output("file #{output}")
    assert_match "PNG image data", file_output
    assert_match "100 x 100", file_output
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
