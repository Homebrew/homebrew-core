class Imgproxy < Formula
  desc "Fast and secure server for resizing and converting remote images"
  homepage "https://imgproxy.net"
  url "https://github.com/imgproxy/imgproxy/archive/v3.20.0.tar.gz"
  sha256 "ef7bdec2ae247c7e3f302a332cdaaf0d2bb59f7ef6c88b3bbd539c95ab70cbb7"
  license "MIT"
  head "https://github.com/imgproxy/imgproxy.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "48678315ce6e216e0ed0e803e0e469ed31042fd1939761df494967371468e7e7"
    sha256 cellar: :any,                 arm64_ventura:  "03857103267595d154d1cee4496092652d6a0fe2a81b9b68ead48107a93bc6b9"
    sha256 cellar: :any,                 arm64_monterey: "47cdc8c0b57b1e26d82e7473287ba10bf89658e3f655872ffb8d790bcc1f8e74"
    sha256 cellar: :any,                 sonoma:         "2915e0aa706d700570dc66832528bfc41007314b8925836b96c1c637fac39a37"
    sha256 cellar: :any,                 ventura:        "aa45aa9de63aee36de0437facd9ec368492a6321f9e21cbef9326f4c9397c7d6"
    sha256 cellar: :any,                 monterey:       "3a588911ac1be8e42674e96237d3513fa1b1585474766dd05f70a7a786bd0c0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "66c0faacbd3b961910c27b00073b7cea49d85ad4639ed4ac5396e9b5fcc82e37"
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
