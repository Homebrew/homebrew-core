class Imgproxy < Formula
  desc "Fast and secure server for resizing and converting remote images"
  homepage "https://imgproxy.net"
  url "https://github.com/imgproxy/imgproxy/archive/v2.13.0.tar.gz"
  sha256 "6563480c041d960fc8f2a2499a7284b3b2ddf3b35da8b118bc8d139858463bb8"
  revision 1
  head "https://github.com/imgproxy/imgproxy.git"

  bottle do
    cellar :any
    sha256 "b546d7aa31858474761ec0474beef799c3851d6d4f5a8f731d4cf398f7e9d030" => :catalina
    sha256 "02c89fb21138a9dd69403a956bd38748dbbb7f00add5aa9d4a1f8a852ad2623f" => :mojave
    sha256 "82d9bc4b4af8ebaf884f8d72ba2e4b93c76cbcb3dc1c3fbe6d06bae7271b058e" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "pkg-config" => :build
  depends_on "vips"

  def install
    ENV["CGO_LDFLAGS_ALLOW"]="-s|-w"
    ENV["CGO_CFLAGS_ALLOW"]="-Xpreprocessor"

    system "go", "build", "-o", "#{bin}/#{name}"
  end

  test do
    port = free_port

    cp(test_fixtures("test.jpg"), testpath/"test.jpg")

    ENV["IMGPROXY_BIND"] = "127.0.0.1:#{port}"
    ENV["IMGPROXY_LOCAL_FILESYSTEM_ROOT"] = testpath

    pid = fork do
      exec bin/"imgproxy"
    end
    sleep 3

    output = testpath/"test-converted.png"

    system "curl", "-s", "-o", output,
           "http://127.0.0.1:#{port}/insecure/fit/100/100/no/0/plain/local:///test.jpg@png"
    assert_equal 0, $CHILD_STATUS
    assert_predicate output, :exist?

    file_output = shell_output("file #{output}")
    assert_match "PNG image data", file_output
    assert_match "1 x 1", file_output
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
