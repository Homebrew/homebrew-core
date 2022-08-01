class Imgproxy < Formula
  desc "Fast and secure server for resizing and converting remote images"
  homepage "https://imgproxy.net"
  url "https://github.com/imgproxy/imgproxy/archive/v3.7.0.tar.gz"
  sha256 "2c68077714672400ccb7c029f6f1844daff597966f411c24cba60077828fa6a5"
  license "MIT"
  head "https://github.com/imgproxy/imgproxy.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "6d3aa0b27a428630fe5d431e3e46e2e922ac3f31f024d92f497a0f5de5f7ac05"
    sha256 cellar: :any,                 arm64_big_sur:  "8cd05a722e3c4a44912a79a2b4a5947103de6800abd931f923b52dd76e8a068a"
    sha256 cellar: :any,                 monterey:       "98575188a5689992ac46642eafc6d79e2cb8e17a8169558fab3efd3906afe240"
    sha256 cellar: :any,                 big_sur:        "aa588b29830852f151dc379fd1bb1e6074fbfeaa0efe0c0e6518b6fbbe98c328"
    sha256 cellar: :any,                 catalina:       "5372a5c430fa0cd157f65a6b1442199ff482bdd81330c95519722bafbc0682e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2daaf387f7a028599678357ebcbc8ec147abab4f75b80923b88d4397bce81e43"
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
