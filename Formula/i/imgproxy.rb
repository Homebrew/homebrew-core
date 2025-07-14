class Imgproxy < Formula
  desc "Fast and secure server for resizing and converting remote images"
  homepage "https://imgproxy.net"
  url "https://github.com/imgproxy/imgproxy/archive/refs/tags/v3.29.1.tar.gz"
  sha256 "c6881d091ea857d7d56cbb16da28c7b22280001d063822c629c8dd011c432b2c"
  license "MIT"
  head "https://github.com/imgproxy/imgproxy.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b961311ff59162bc81461c8a688b8d0ffe77d30b5f21b82243b9779c1b64e0cc"
    sha256 cellar: :any,                 arm64_sonoma:  "fdce9b280166ac782c45cc7b7fc898d50d51452f02706ff49013c5b215c5b6f4"
    sha256 cellar: :any,                 arm64_ventura: "311b50e7164ee3e3f1bac120cb5f71cddf0c5c65435b10f4eeee7e17e294217c"
    sha256 cellar: :any,                 sonoma:        "419e5c9c4d1f5b50cdc087e43c94aac874e08b30873362a821b54b8dd87439ca"
    sha256 cellar: :any,                 ventura:       "fa6fe6d3e73cdd70ae112dc55e10c90a85d5a507d3211369509bc12981e8ff7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "801287e68e0521f2f341a18a58a712ca4c385abab49a1e7f588d9d407b27486a"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build
  depends_on "glib"
  depends_on "vips"

  on_macos do
    depends_on "gettext"
  end

  def install
    ENV["CGO_LDFLAGS_ALLOW"] = "-s|-w"
    ENV["CGO_CFLAGS_ALLOW"] = "-Xpreprocessor"

    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    port = free_port
    cp test_fixtures("test.jpg"), testpath/"test.jpg"

    ENV["IMGPROXY_BIND"] = "127.0.0.1:#{port}"
    ENV["IMGPROXY_LOCAL_FILESYSTEM_ROOT"] = testpath

    pid = spawn bin/"imgproxy"
    sleep 20
    sleep 50 if OS.mac? && Hardware::CPU.intel?

    output = testpath/"test-converted.png"
    url = "http://127.0.0.1:#{port}/insecure/resize:fit:100:100:true/plain/local:///test.jpg@png"

    system "curl", "-s", "-o", output, url
    assert_path_exists output

    file_output = shell_output("file #{output}")
    assert_match "PNG image data", file_output
    assert_match "100 x 100", file_output
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
