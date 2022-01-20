class Imgproxy < Formula
  desc "Fast and secure server for resizing and converting remote images"
  homepage "https://imgproxy.net"
  url "https://github.com/imgproxy/imgproxy/archive/v3.2.1.tar.gz"
  sha256 "a7cd3f01e678856dbed9dc5323175c6b37e6aacd508c1fbf306a439ba36ea0b7"
  license "MIT"
  head "https://github.com/imgproxy/imgproxy.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "29f9c8234a8faa4c9da2e6d334b5b4ed7af08dff50f07ee6717f6dd4ebeda72b"
    sha256 cellar: :any,                 arm64_big_sur:  "f21e01ed075429792a63ca9097184169b6934b3a44d14fa0db0e309e06cd0b76"
    sha256 cellar: :any,                 monterey:       "9c5c22d05e591e004eb6039df6cc6ddf984e79ccc71e93e15d8df0fa9da52040"
    sha256 cellar: :any,                 big_sur:        "16ac6cfcbfa8864b679dbf32ccfe64b12884d00eab28ea32cd0084ae453c16ce"
    sha256 cellar: :any,                 catalina:       "5db0be2a0b335988ebcfa28047026ad55db2642b84ac69a35eb5a66f2da5e399"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "644514454abb62f6b99fb803819be788b30384776f5a53ff5d0e91ec2e0c2802"
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
