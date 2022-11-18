class Imgproxy < Formula
  desc "Fast and secure server for resizing and converting remote images"
  homepage "https://imgproxy.net"
  url "https://github.com/imgproxy/imgproxy/archive/v3.11.0.tar.gz"
  sha256 "34dd1be235ba8d3578112a6fae413edb3c11d8d2426c32cf06957ad1fb19cbd0"
  license "MIT"
  head "https://github.com/imgproxy/imgproxy.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "957945e5736b0fa0b06ce5e26b174f291073202c7ca5ab693e2f018bf8481edf"
    sha256 cellar: :any,                 arm64_monterey: "994baf0a0f1c285047b4c81f7fe2e60294afdda0b7594b8e716a0786fbcb9b1b"
    sha256 cellar: :any,                 arm64_big_sur:  "eab39a868d53b652133208c3a153c6135e7bc48e591ffb68093be71fd83e9d20"
    sha256 cellar: :any,                 monterey:       "c2681ef09d858e257d5761083fc7ee06393a048648516db169e849ea5ce18486"
    sha256 cellar: :any,                 big_sur:        "fd2446bf7d47af5a7b28ac5b84e1b4c87603e12491fc1d3e7b8aa63bc4bf3f09"
    sha256 cellar: :any,                 catalina:       "5be4a994f5c706d5c522b853f94e7113b6d5c4d4a0f55112aac42f10ed2e2ab7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2e90e2cb6fa6a3700cf5c12bf7e4b7149f6ce62d90590cec6648bdbe4671a92f"
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
