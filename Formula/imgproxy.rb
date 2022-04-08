class Imgproxy < Formula
  desc "Fast and secure server for resizing and converting remote images"
  homepage "https://imgproxy.net"
  url "https://github.com/imgproxy/imgproxy/archive/v3.4.0.tar.gz"
  sha256 "6c6ad103e6d2c7a5fe0ff3f5d3b48726b66403d854ba8e79f221c57c5a5a2705"
  license "MIT"
  head "https://github.com/imgproxy/imgproxy.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "30ff699f2c774aab001f88a03409f7810e443f343a6155f35e214918e77b58c9"
    sha256 cellar: :any,                 arm64_big_sur:  "bc31aca24e026512d5eee40debd8e2829f27ecaa7c94982c93ae5dffbca66683"
    sha256 cellar: :any,                 monterey:       "d93c0df2b77a6948263faeb5238d55ade568f6a35085ec24320b0d760f57ec7c"
    sha256 cellar: :any,                 big_sur:        "cbc0321ccbef63733b4452a58606aab7991ad8b5b2f7534de64d196c75495785"
    sha256 cellar: :any,                 catalina:       "d330d74711f446d04d685ba1219b9e7a5a483220510a15eee2adc3594be2182e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "87a6977d04dd275a02156cd5fc776a91e75852d3eddb960f8168d9445536af3c"
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
