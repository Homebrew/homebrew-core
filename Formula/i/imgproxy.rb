class Imgproxy < Formula
  desc "Fast and secure server for resizing and converting remote images"
  homepage "https://imgproxy.net"
  url "https://github.com/imgproxy/imgproxy/archive/v3.19.0.tar.gz"
  sha256 "a175229be4d27e1beb0417298f8b573f15b92f089c042282ab9842a675a42050"
  license "MIT"
  head "https://github.com/imgproxy/imgproxy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b2566545d16514f3057218a3d8d8a23a388d09c65c569788f323a3921f20c4f6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cee946674c921b38b64ed9c38d2350eb252d59ca9670f34b29ac6521207b92b8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "479b9f9a9c57bbdbf77cf18fd4856a780fb07cda21d3f5deecc7745d1365bde7"
    sha256 cellar: :any_skip_relocation, ventura:        "cfded487ba77086e27653cd910ceda91c09fbd655f72ac15074d044a1a17128c"
    sha256 cellar: :any_skip_relocation, monterey:       "b8520cdd3147c0ae93a0cb738ddc2fec857366eeba74f8f50398ff401ac0e0b1"
    sha256 cellar: :any_skip_relocation, big_sur:        "effd35e9328f10b657dde0aa4f1d72a0f1033be894078080f948947d3bca4b28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "43f78e078b477875acafd1339321c53804dbfeeaee366d8e303159f0f95f5aef"
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
