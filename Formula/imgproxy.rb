class Imgproxy < Formula
  desc "Fast and secure server for resizing and converting remote images"
  homepage "https://imgproxy.net"
  url "https://github.com/imgproxy/imgproxy/archive/v3.14.0.tar.gz"
  sha256 "b7cba8fa6dc1bf0ec5c5ab0b791877bbe9037cc474657c2bd8c7d2ab21fa220e"
  license "MIT"
  head "https://github.com/imgproxy/imgproxy.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "aeb68d11283f912d42bee3a76e4ad07361d2de8b529d6c818b543648de698edb"
    sha256 cellar: :any,                 arm64_monterey: "c87764715ca748c902f1515d83a03ddb11da13dfaf8dcfc15fb06cdbb8e3ace3"
    sha256 cellar: :any,                 arm64_big_sur:  "154c4dd09276db31aa2e3da4f116ddffefa5972756589d59576c557c64fce455"
    sha256 cellar: :any,                 ventura:        "05780a37095068412026cf2ba038920283d0ea476e8487400cfb7e3d2bc16f16"
    sha256 cellar: :any,                 monterey:       "fff82b64b618b7793b892e87b97cbda41bbb892d3df0adb809e7e807cebbe0aa"
    sha256 cellar: :any,                 big_sur:        "69809e1949b6fae9d1d0ce3ce9b8060f56d12e8291dd1b35fd73583dcd539ae3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "97bf30d1a81f0b7e056736d54052bcecd605c59cee8ff1ada9a1d66455d73352"
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
