class Imgproxy < Formula
  desc "Fast and secure server for resizing and converting remote images"
  homepage "https://imgproxy.net"
  url "https://github.com/imgproxy/imgproxy/archive/v3.1.1.tar.gz"
  sha256 "7dccb461ad7bf7cce5477715049d9915ba75fde2a09b0310ad9741b162aa0b93"
  license "MIT"
  head "https://github.com/imgproxy/imgproxy.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "6779210b917a46aac2a04ad31fddc5abe850516dc3ae04e37291b2e0b09d4ab1"
    sha256 cellar: :any, monterey:      "9b44caeede88fea47758932603aa846ce277cd0c04df6e2523a5630f12f16541"
    sha256 cellar: :any, big_sur:       "62b6fa6b4f0211e10a8ee9cd6c98c170087c0bf672840004716785399e929d68"
    sha256 cellar: :any, catalina:      "77969b80387bd94e74e0fa1fa499169731bb26660c1391ea1a5acac6e730d1c8"
  end

  depends_on "go" => :build
  depends_on "pkg-config" => :build
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
