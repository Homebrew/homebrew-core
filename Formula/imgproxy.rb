class Imgproxy < Formula
  desc "Fast and secure server for resizing and converting remote images"
  homepage "https://imgproxy.net"
  url "https://github.com/imgproxy/imgproxy/archive/v3.2.2.tar.gz"
  sha256 "be0beb29fab9e3bd8f36a6ba90a933257d9bf8322a130aef6db17503ccbbf6ac"
  license "MIT"
  head "https://github.com/imgproxy/imgproxy.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "3b4ec54407c583dd7eefa093a083a7546e839b54c6a9a9db6d4553a62247c911"
    sha256 cellar: :any,                 arm64_big_sur:  "3e8fe2aeadf5f78181b3324f6987253cbe7c85d27e0d54232ebdd6516f42f209"
    sha256 cellar: :any,                 monterey:       "fd0e6ac4047c501db0c5e77998a4709054e5a19b981679913f615f60db9c7c02"
    sha256 cellar: :any,                 big_sur:        "ac16c9ef6d020d3a782e441e1492617fab8207d0890f04a16f18ba7d87aaf7bd"
    sha256 cellar: :any,                 catalina:       "e03e313d93a4687f6581ed52a1e0e6b9648a1d445bb3f453bc68914a9e72139a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6afe1c4536c4ede8ef107287b59f8a7f5aebd2b5273a3b63b6425110ebeb6db1"
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
