class Imgproxy < Formula
  desc "Fast and secure server for resizing and converting remote images"
  homepage "https://imgproxy.net"
  url "https://github.com/imgproxy/imgproxy/archive/refs/tags/v4.0.18.tar.gz"
  sha256 "ceaca8cd8cd307b3407919ce3d98cf7f29a5efd3d43433df0d87783e80a96891"
  license "Apache-2.0"
  head "https://github.com/imgproxy/imgproxy.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "af7a95a409c5d1cc48583d4e832e822fd897125d78847e9fab1df0a96d9a7765"
    sha256 cellar: :any, arm64_tahoe:       "6b66b47b0e0fa03bc9320d30e45e61d8a11cbc0e791601757ca75990cadde3bf"
    sha256 cellar: :any, arm64_sequoia:     "b255a53df1e9a4f43abb2110e3c2a536daf11a1f8cf7e3086955a6003b7d698a"
    sha256 cellar: :any, arm64_linux:       "b0015b1010fd84b575fa42409313e9f2f016ac7d6bd3de44a13091a70a9116e5"
    sha256 cellar: :any, x86_64_linux:      "755f1cdb1952038239850dd9cb035c33a9e29b948982b0eb3ec5dfcd4411d046"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build
  depends_on "glib"
  depends_on "vips"

  on_macos do
    depends_on "gettext"
  end

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_LDFLAGS_ALLOW"] = "-s|-w"
    ENV["CGO_CFLAGS_ALLOW"] = "-Xpreprocessor"

    # Workaround to avoid patchelf corruption when cgo is required
    if OS.linux? && Hardware::CPU.arch == :arm64
      ENV["CGO_ENABLED"] = "1"
      ENV["GO_EXTLINK_ENABLED"] = "1"
      ENV.append "GOFLAGS", "-buildmode=pie"
    end

    system "go", "build", *std_go_args, "./cli"
  end

  test do
    port = free_port
    cp test_fixtures("test.jpg"), testpath/"test.jpg"

    ENV["IMGPROXY_BIND"] = "127.0.0.1:#{port}"
    ENV["IMGPROXY_LOCAL_FILESYSTEM_ROOT"] = testpath

    pid = spawn bin/"imgproxy"
    sleep 20

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
