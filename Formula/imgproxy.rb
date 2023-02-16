class Imgproxy < Formula
  desc "Fast and secure server for resizing and converting remote images"
  homepage "https://imgproxy.net"
  url "https://github.com/imgproxy/imgproxy/archive/v3.13.2.tar.gz"
  sha256 "d43627584551afc6936ca9cdd71549a961e7df969fc14291aa223755c5c72f19"
  license "MIT"
  head "https://github.com/imgproxy/imgproxy.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "3669282d2e64d9d8e6ac1295225ca4c4cbb462c64ca7b4ddd0986b44a1c154ed"
    sha256 cellar: :any,                 arm64_monterey: "4c82c03f171e297afbed558441418ea2fb7a55d31f722da01f6b3123e4df4776"
    sha256 cellar: :any,                 arm64_big_sur:  "385d966dbc4f2ccc1d0652da152b9585787351b6cc7cac0eca32ad3105714aba"
    sha256 cellar: :any,                 ventura:        "81fa4ee918974f31d31d3f01c7870227a5f7cdc6043469259b5a1c3dcb628078"
    sha256 cellar: :any,                 monterey:       "c64cb788cc52cc143802c572d83bfb3b5f1ef5d48cb2b72ab8420de358516787"
    sha256 cellar: :any,                 big_sur:        "5bbfdfcbf5afc0afe5a77c1ce2afda26d86709415f1ab222798595a871577022"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "143cfa5eedc96e32a58c0f1d4facee531a9cf2691c2fa3787a3428f87a244223"
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
