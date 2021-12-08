class Imgproxy < Formula
  desc "Fast and secure server for resizing and converting remote images"
  homepage "https://imgproxy.net"
  url "https://github.com/imgproxy/imgproxy/archive/v3.1.0.tar.gz"
  sha256 "a5f5509f687ee7fccea4e09de021fad794cddde7b3743f43a0be243b57b6639c"
  license "MIT"
  head "https://github.com/imgproxy/imgproxy.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "10fca02ca29c25bde18e6b2d11f6696bfa00faf4b2173873591ef3eb20b2714c"
    sha256 cellar: :any, monterey:      "90e9ec5d3bc1f52eff9415b8139aff2e4a3e5f85dba50af2c9d0a6e91b0fce80"
    sha256 cellar: :any, big_sur:       "e941ec2b998854b77445be45e4967ad1cf20656fe30ead52bc97cd38509e7713"
    sha256 cellar: :any, catalina:      "721182891a751565ea6df59eaf4ca58fbc014d3ff4c26b7e97a4cbb9b8d8b89f"
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
