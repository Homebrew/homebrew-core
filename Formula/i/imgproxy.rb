class Imgproxy < Formula
  desc "Fast and secure server for resizing and converting remote images"
  homepage "https://imgproxy.net"
  url "https://github.com/imgproxy/imgproxy/archive/refs/tags/v3.25.0.tar.gz"
  sha256 "14c76764b33174eebaf22f201b325dfa36434b6dcd9f79a86bb925a5eecfe69b"
  license "MIT"
  head "https://github.com/imgproxy/imgproxy.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "9a71612b4b8f5aca5b1144d7c1476a4d79a4f3c6da8ffeaf08fa23c99744a401"
    sha256 cellar: :any,                 arm64_ventura:  "e55f81fa301e2f1003bda6e5c01436ed0d31deb56cc27216235fe5b8e40f7f0b"
    sha256 cellar: :any,                 arm64_monterey: "00f45ce78e9831b266d3b24ab19228455484f6f2dfd0bc75fc1eb2d231c2eae4"
    sha256 cellar: :any,                 sonoma:         "5a8e98f9fe31b23adf203f7423152853e3d5b9ea10a0f9a26e6f3249cb4b999e"
    sha256 cellar: :any,                 ventura:        "d9f6ea636b8bc5a393f21f723d5930c06c619d71b36e8f8f3582feece1dc0b01"
    sha256 cellar: :any,                 monterey:       "448068ccb9462038251a68544b83af4178b386d563135c2e37a5fc3685b9187a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1062a9646ca6c48fa8d367bbbc080c6e14557e1de6ed936812e8cfd9cf3d3fa5"
  end

  depends_on "go" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "vips"

  on_macos do
    depends_on "gettext"
  end

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
    sleep 30

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
