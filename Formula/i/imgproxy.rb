class Imgproxy < Formula
  desc "Fast and secure server for resizing and converting remote images"
  homepage "https://imgproxy.net"
  url "https://github.com/imgproxy/imgproxy/archive/refs/tags/v3.24.1.tar.gz"
  sha256 "dc75ffd728450b04c8eaa7cd172836d518b129d552026bbaef87fd32e078573d"
  license "MIT"
  head "https://github.com/imgproxy/imgproxy.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "5ff11e9477cb9e02f0b0a7652ddc2ac7f6f4ea74a3a6aa7ebfbbb42ae4a388be"
    sha256 cellar: :any,                 arm64_ventura:  "88d2278740dc1b7633b7515afc2f984c8bf58955e6fe05c873fa61acda9f9d9c"
    sha256 cellar: :any,                 arm64_monterey: "72d894718e527f80f120bbfdde49a2d516fabc7a356fe2ecfd88cb09a212da3f"
    sha256 cellar: :any,                 sonoma:         "e566bad032ce5be97c26f9c87c5d7c0dea33d35f0f1aaaeeb3722866c5671203"
    sha256 cellar: :any,                 ventura:        "91822815cb24b63cb7ffafa207496ab6b5b2d2aba53aa23d8104346dbb5141f1"
    sha256 cellar: :any,                 monterey:       "819a662654d393903b42f11244dd2f0e11768632a6fa8663a3b4b640d85376a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba31fb3a5ea84d76f6095503bd2b7cb40ed4dd385f67605103a9ba359e2f9395"
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
    sleep 30

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
