class Imgproxy < Formula
  desc "Fast and secure server for resizing and converting remote images"
  homepage "https://imgproxy.net"
  url "https://github.com/imgproxy/imgproxy/archive/v3.13.1.tar.gz"
  sha256 "d60de3fc52f0872093af8a27377d72af08418685e2cc59dc3d18f07b532815b4"
  license "MIT"
  head "https://github.com/imgproxy/imgproxy.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "782a0f80ad04196b0738e11e290f05be9d3446e82d59abe4ebefe3adfcb8d510"
    sha256 cellar: :any,                 arm64_monterey: "1697a1b681ecf5d1508778f55870d8ae012d7369af19e6a474578045c1971984"
    sha256 cellar: :any,                 arm64_big_sur:  "c30446cf8cb83b9968d430b5a412417e86ebbd25ebe9fd37a6395c8a45f7ea79"
    sha256 cellar: :any,                 ventura:        "81a92bd0e9b19f8f9863b291c66c19ad8613875fc2a54a2ebc691d0a99efbda4"
    sha256 cellar: :any,                 monterey:       "e3a24c0000c3b05d8d9c61a50f58cb885c06d2c27608ebf3d73cc413d68efd57"
    sha256 cellar: :any,                 big_sur:        "9574bee1a9dd9b2e79afb2b3d3834d3cbc0030c376f2bbef681336bdc2dd0eeb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee821630fe56ec33e004ec30b5f420b2bd50639d558ece1d1f872d1bd2e9f2cb"
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
