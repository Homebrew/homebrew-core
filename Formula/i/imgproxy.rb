class Imgproxy < Formula
  desc "Fast and secure server for resizing and converting remote images"
  homepage "https://imgproxy.net"
  url "https://github.com/imgproxy/imgproxy/archive/refs/tags/v3.26.0.tar.gz"
  sha256 "6125d230b35cca2b0ca53e06afd82b1bb01aafd0eee2e6617cbd9f5fab6c9e31"
  license "MIT"
  head "https://github.com/imgproxy/imgproxy.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2586c3c66d84edb11df56d1b93a2b5da7ff2d5ff2a4bce8a2a618affd9190c4e"
    sha256 cellar: :any,                 arm64_sonoma:  "f5ceae4788d8dafaf2e56cde36aa2bcff184311649c7eab0944e4061f4f57d9d"
    sha256 cellar: :any,                 arm64_ventura: "05bcd276740aa58bcd57113a13d948432f37d0e23bbb4d7b3a20902d84223342"
    sha256 cellar: :any,                 sonoma:        "2aeceefd32490aceaee8274be9348034d79eab027035bcfb5f043e0dc5dd163d"
    sha256 cellar: :any,                 ventura:       "9e6ebcc207c5e9a0615b683ec18bddde7c546657a3e9687ffab43997966f1fba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "04760e453ae95be814da1e5617da46dd5117e555a2546c218ffa2436878cf947"
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
