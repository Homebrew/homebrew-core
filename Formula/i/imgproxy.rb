class Imgproxy < Formula
  desc "Fast and secure server for resizing and converting remote images"
  homepage "https://imgproxy.net"
  url "https://github.com/imgproxy/imgproxy/archive/refs/tags/v3.30.0.tar.gz"
  sha256 "24e6f5277f1673c7b0c1617f7c4956d2ad1bac06611a56d95228dd6414080bbe"
  license "MIT"
  head "https://github.com/imgproxy/imgproxy.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f7558449baeca831e5efd6f460157bc78e3c2268dc3105424b35ccafbf991657"
    sha256 cellar: :any,                 arm64_sequoia: "20d338e528b1bb3cf01a356a1183b4e622acf27586c3c4be2917819a3421ea0d"
    sha256 cellar: :any,                 arm64_sonoma:  "8f100f7521911399bc0c1284260da6b18a1531b5bf70aad4e115b6d098c0f0d9"
    sha256 cellar: :any,                 sonoma:        "279d4c9644c9d91bd706d96334c64fe8bd45150484de0566149ac1fd3650d085"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cea2d90e0621c2730b9cf5c843a6ac31dee0fdf181d9bf03b93a5c54f56eaa78"
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
