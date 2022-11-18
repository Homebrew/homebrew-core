class Imgproxy < Formula
  desc "Fast and secure server for resizing and converting remote images"
  homepage "https://imgproxy.net"
  url "https://github.com/imgproxy/imgproxy/archive/v3.11.0.tar.gz"
  sha256 "34dd1be235ba8d3578112a6fae413edb3c11d8d2426c32cf06957ad1fb19cbd0"
  license "MIT"
  head "https://github.com/imgproxy/imgproxy.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "7f961a55bc311fbf7766abf757029e60f3d91fa49fc2edb604b7f1e5dae05ff6"
    sha256 cellar: :any,                 arm64_monterey: "305f06819cd9b5fcb17d64fa2b80d15a4e2ba27c8b95f6ed507e74b541c2d984"
    sha256 cellar: :any,                 arm64_big_sur:  "404b506ad3f449672b54e069fc2c3cfcd86ed2dc749dc280ffa5d39cdb7fd84b"
    sha256 cellar: :any,                 monterey:       "7a22a7c9c642a662be447ce3e512175be6fe448f7fcc511a6825c83e408d825f"
    sha256 cellar: :any,                 big_sur:        "94d20cc1979e641fbfb7a148e185ac435a2589bb1c3f22aca18b2213f60953be"
    sha256 cellar: :any,                 catalina:       "0e10a0142a0cf2214431df16ac22ae04dce7c1b1c23064a41c57335d63215d9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "047318cf29d4a13461a48fe38e4230699bd8137a771bb2081ad9777a4153f75f"
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
