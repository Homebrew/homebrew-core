class Imgproxy < Formula
  desc "Fast and secure server for resizing and converting remote images"
  homepage "https://imgproxy.net"
  url "https://github.com/imgproxy/imgproxy/archive/v3.3.2.tar.gz"
  sha256 "45151781f0d419a2293be97c5e26ed91826a7232eeb298937438cc7b4a4f2a31"
  license "MIT"
  head "https://github.com/imgproxy/imgproxy.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "47e95a04daf150ff0b071e94334dd9c85e101a1b8eeccc10cc338407e31f0367"
    sha256 cellar: :any,                 arm64_big_sur:  "c4dea30186c958187e40e9f61af7c7258a1163603bec243825211c6b5584c4ee"
    sha256 cellar: :any,                 monterey:       "cb50ace1e00751416584f828fa1ec8e54bdab6b98805955ce734c7866934567a"
    sha256 cellar: :any,                 big_sur:        "26fadbc1bef1290d26caa6458522b83d2adbe0009a3e78b156cd084d5a6bad3d"
    sha256 cellar: :any,                 catalina:       "39221ea626d9f62404895d5711eea4a730ee40ec921f362af659ca385b75b6f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "76769220fb0343857000f6000e5d97762557a70e5aab6064b8e035d610600683"
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
