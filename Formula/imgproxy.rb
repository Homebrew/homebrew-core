class Imgproxy < Formula
  desc "Fast and secure server for resizing and converting remote images"
  homepage "https://imgproxy.net"
  url "https://github.com/imgproxy/imgproxy/archive/v3.3.3.tar.gz"
  sha256 "a322608d1c6a32d5e0e3fffe03be4856a6245bf73fca9b24dd5f4265a836648c"
  license "MIT"
  head "https://github.com/imgproxy/imgproxy.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "efa3e859163072261e08b5845c6746d4f435b0a818aa1666796e6a18ab71ce9a"
    sha256 cellar: :any,                 arm64_big_sur:  "a07dcb32475955bfd2b2cb5996a58c31204dc5795679cd53d97830a85fdaf945"
    sha256 cellar: :any,                 monterey:       "f048b288a3988c347850042368a1b9f67043be39a72c6e77887ac18cece92ab4"
    sha256 cellar: :any,                 big_sur:        "cc575fc7de9966ae8ba9562d4b667aa3799091c74b16639e68c84fbf7573b9e8"
    sha256 cellar: :any,                 catalina:       "3f8280977ff468a19e852754960fccfedb9214afd1c2ca7445ba123638cc64af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1248b8a17744533f47ee12cf88b253b9215239bfd3b19fcf8acb894d195a1936"
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
