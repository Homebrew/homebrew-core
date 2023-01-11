class Imgproxy < Formula
  desc "Fast and secure server for resizing and converting remote images"
  homepage "https://imgproxy.net"
  url "https://github.com/imgproxy/imgproxy/archive/v3.13.0.tar.gz"
  sha256 "08d263e065fef7170ccb9e0b4e910c7d80b2b19deefac8749d016c3efb7d1414"
  license "MIT"
  head "https://github.com/imgproxy/imgproxy.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f3984acfffabeb21e4880eee0d4d5842c7b1ea728c7e6e5150b749cca2685d68"
    sha256 cellar: :any,                 arm64_monterey: "87d8db0d8f4c7073fe7087e10c6bd4c97bcd6ff9819e1d72feb7d8c2fe3ac147"
    sha256 cellar: :any,                 arm64_big_sur:  "c7aef445176b216b2c9e26b228202839ec5c13a9df65434a61602028d9648679"
    sha256 cellar: :any,                 ventura:        "25aad22b5174211942a969a9a8390584fff66417ecdfd2878a2865eb91e2cdad"
    sha256 cellar: :any,                 monterey:       "783d3102e472a97f865c668e4234484b035d954a83519c615bb2eeceadc28d92"
    sha256 cellar: :any,                 big_sur:        "919b749344630ffebc247754f33ffafc368d778f4e2ca1df53f16075eeaa0fd8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "453224fe3fad849009df2068db173de62e5b20670bf73ba30b063b7004b9d27c"
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
