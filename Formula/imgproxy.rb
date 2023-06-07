class Imgproxy < Formula
  desc "Fast and secure server for resizing and converting remote images"
  homepage "https://imgproxy.net"
  url "https://github.com/imgproxy/imgproxy/archive/v3.18.0.tar.gz"
  sha256 "f81b4eaf2d85bd29e0b94a2957b45013c878fd10d33623aa3f199c32243636b1"
  license "MIT"
  head "https://github.com/imgproxy/imgproxy.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "2329a014310d84f6d2f6ffe2f17811e2d1f18e841e68206238a9b78a1658e5d9"
    sha256 cellar: :any,                 arm64_monterey: "6b9d192b1a05b4bc15b0ff1a83585eb97b144d7087e6a1579fcf38a54f4eabde"
    sha256 cellar: :any,                 arm64_big_sur:  "eab046b54c7ecea7958a73cc1c9be7a9171057e9cdff114d2ddecf00c98e912f"
    sha256 cellar: :any,                 ventura:        "c515b59cd72eb35666f88d5d93317e69ab664b7ef4bb64d960bf7b9c0174a10e"
    sha256 cellar: :any,                 monterey:       "8e94a6f20f26c692fab269d4d89901a4ed36d0956199c131d94a97c2035bf818"
    sha256 cellar: :any,                 big_sur:        "e9d3e7015dd6fdb623808de39ac53af1c319b55142b57a11def35371e4bed301"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f73be79d21a99ff842c45416302969241f0e850eb7b8da0eb37e1253d2faf189"
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
