class Imgproxy < Formula
  desc "Fast and secure server for resizing and converting remote images"
  homepage "https://imgproxy.net"
  url "https://github.com/imgproxy/imgproxy/archive/refs/tags/v3.23.0.tar.gz"
  sha256 "d48721d96bf2974af4b6e612d0cdb27484d132c9f9ad17abe5c2095f22beeb8d"
  license "MIT"
  head "https://github.com/imgproxy/imgproxy.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c5370e288d3086ccba186068bc4bb9622dcf7b070c92f222d2ba595dbc735a6c"
    sha256 cellar: :any,                 arm64_ventura:  "a2ecb5708baf13f8a9f3daab153cec920eb2a61552309982d2a743cd3d282940"
    sha256 cellar: :any,                 arm64_monterey: "fbb0d7718f78d5b21058ec4f3776b99fb94ee290c369d00f96ff26a5dc3f8c16"
    sha256 cellar: :any,                 sonoma:         "767821c8902b087e7910886c6a81fba79a2e5b9c593c72b638b032b61ff83dd6"
    sha256 cellar: :any,                 ventura:        "95b1a63e531b4d640a08c3f1ccc14777e0332850334896b07deaa42443116962"
    sha256 cellar: :any,                 monterey:       "1be09d549953ecab0070f0ac222783e3c032c03ad35960be4426e7b613093a57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c435f4491100b3aff69dbf755a5e6b563c403164c27c0fb3b7dca52f5a43a177"
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
