class Imgproxy < Formula
  desc "Fast and secure server for resizing and converting remote images"
  homepage "https://imgproxy.net"
  url "https://github.com/imgproxy/imgproxy/archive/v3.1.3.tar.gz"
  sha256 "21fb4c9d92e8a169e966c7ec7ebfa4527177cabeb49042e5dd0c7baf32a2824f"
  license "MIT"
  head "https://github.com/imgproxy/imgproxy.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "47e9165144e9e39c11901b2039115d5f0309022935763ddff9fe22801a0ce631"
    sha256 cellar: :any, monterey:      "43d00ac7a86610b9b7c2441d9091e6471379adc7e6604388d97c65e962d3f273"
    sha256 cellar: :any, big_sur:       "5910cfb726fc0965edb80eaafd21f7735edc255fefe06d12961d117ad8d0eea0"
    sha256 cellar: :any, catalina:      "4f2f2a56ae0b33626daafa43417770e69cd9dc12337a25d950d8ebd21526de10"
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
