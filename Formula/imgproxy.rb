class Imgproxy < Formula
  desc "Fast and secure server for resizing and converting remote images"
  homepage "https://imgproxy.net"
  url "https://github.com/imgproxy/imgproxy/archive/v3.2.2.tar.gz"
  sha256 "be0beb29fab9e3bd8f36a6ba90a933257d9bf8322a130aef6db17503ccbbf6ac"
  license "MIT"
  head "https://github.com/imgproxy/imgproxy.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "f436c08ab07a3137ed17341055dc51265a010e1a66fbd42e7794ab8b071e3189"
    sha256 cellar: :any,                 arm64_big_sur:  "dd956d2c16172d844fc5d03339e9b4f8f1dc35ca76beb4374bfa23bc7f08b08b"
    sha256 cellar: :any,                 monterey:       "e8d5dfdd3006a0ef2950932576556d41bf8cf4f34d4d26bf1cbb9a5e46ddb85d"
    sha256 cellar: :any,                 big_sur:        "8a17873b1ebdceb7accd05eb38dd416b044d0bec341096da5f389ef22e92476b"
    sha256 cellar: :any,                 catalina:       "291e224b85576f617ec5ee9dc7585e0902edf385ef73f97ef8941c81821921ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "120667ca3392ea1c882b3881cd19dc377c5f8ef110b0711fc0fe1f68a874429d"
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
