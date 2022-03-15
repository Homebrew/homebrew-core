class Imgproxy < Formula
  desc "Fast and secure server for resizing and converting remote images"
  homepage "https://imgproxy.net"
  url "https://github.com/imgproxy/imgproxy/archive/v3.3.1.tar.gz"
  sha256 "69a9008577b1d425fe05f9d3646b51c2eb35bb267ba325e95c14ad10a04bd1d2"
  license "MIT"
  head "https://github.com/imgproxy/imgproxy.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "7f9bf38a481bf2e352be28defa68712208d77a065a55ee1430ffb8374a1768be"
    sha256 cellar: :any,                 arm64_big_sur:  "46b1d30021c787f8acee860be454a9e05c4149b58a0104b08dd92e289ecdcafa"
    sha256 cellar: :any,                 monterey:       "a2fe0beca29e018cce603a57fa23ca23bed931e671310cfd3509335cf072b461"
    sha256 cellar: :any,                 big_sur:        "c0e992a4b0951200bfad9077770de9c901f1843085fa840fedb3b36528b40b28"
    sha256 cellar: :any,                 catalina:       "da00000c01b12536fcd8d3162ec6bb060bb9eb8f5299ebde072cb2aafeaa661b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ad1e0053520f718b27911c40ae2e578da5286f446ef4659cef743f4aa13e0306"
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
