class Imgproxy < Formula
  desc "Fast and secure server for resizing and converting remote images"
  homepage "https://imgproxy.net"
  url "https://github.com/imgproxy/imgproxy/archive/refs/tags/v4.0.15.tar.gz"
  sha256 "a9e21772fa927c83fc1bee70bb2c5fcec2125eab24872ac96c92d325a72ae2b5"
  license "Apache-2.0"
  head "https://github.com/imgproxy/imgproxy.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "0686ed20316f165ff094c86dc0b233f04ac5d57f2c5b3c51b324e17ac3ece524"
    sha256 cellar: :any, arm64_tahoe:       "4efe9c8278d2d0a82a6985be906e15bdf7f61cf86fd2c503dcfd567a46a31bb2"
    sha256 cellar: :any, arm64_sequoia:     "16200e8e483066bbab2c3148dda90089251928bc7f56e426f727dcec31204f68"
    sha256 cellar: :any, arm64_linux:       "bcabb94f1612236deb97a8d67898ff1e2dc957d97f9e9aa04f5858f9e0efbc77"
    sha256 cellar: :any, x86_64_linux:      "f9cc47f2d072fa1954549a6be89c346447a9632d7bee28e47a77147d4888d635"
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
