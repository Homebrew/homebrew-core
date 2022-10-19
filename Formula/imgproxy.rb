class Imgproxy < Formula
  desc "Fast and secure server for resizing and converting remote images"
  homepage "https://imgproxy.net"
  url "https://github.com/imgproxy/imgproxy/archive/v3.9.0.tar.gz"
  sha256 "e1cb4065b190840d99059e037a9ee64cf9efed5408c632016f88da0fe772dbf6"
  license "MIT"
  head "https://github.com/imgproxy/imgproxy.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "38626b6fb55500e91add910b256c1c85003069a4a1aaaf8ff8f3a4c589ee0668"
    sha256 cellar: :any,                 arm64_big_sur:  "4154aaec6586a4ce65801147049eec769ba2b2ebaeb2c48c172a8851624c2c13"
    sha256 cellar: :any,                 monterey:       "7c15f2be4d84bba235118fbbf47f70c0e3e253f233127639b0640546fa31101f"
    sha256 cellar: :any,                 big_sur:        "c9a80aae3b51b93f4e8647f0e4813268ac6c3bc1e4f4bbf60fdf597d2a76591f"
    sha256 cellar: :any,                 catalina:       "95815a8b11c49332a152a801c82f4faeb8914672d0eecda3b82f352ede2c05d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f1d22f79a5eed79695aab7a1b262db65b65a00dda9c37fd89412ad67ab7fd499"
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
