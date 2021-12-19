class Imgproxy < Formula
  desc "Fast and secure server for resizing and converting remote images"
  homepage "https://imgproxy.net"
  url "https://github.com/imgproxy/imgproxy/archive/v3.1.3.tar.gz"
  sha256 "21fb4c9d92e8a169e966c7ec7ebfa4527177cabeb49042e5dd0c7baf32a2824f"
  license "MIT"
  head "https://github.com/imgproxy/imgproxy.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "a63b35c69283b98b52b7d546e6b375e4db7da20ad742fd4c1378a5f74cdfb525"
    sha256 cellar: :any, monterey:      "8f16b677caef4202642e251025ec2c01d155ec842b49e1720f81276f098dda1d"
    sha256 cellar: :any, big_sur:       "7bfdd0dbd0861d145907bd4db2dcedf44a73f68123657aed3cab889a6826eec7"
    sha256 cellar: :any, catalina:      "b0d2280418cbc3d8159f77ad0976bb6cbd5d4cf6a5c3a8e4a2823e93c10fa5f2"
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
