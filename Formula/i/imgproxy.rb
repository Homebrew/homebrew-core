class Imgproxy < Formula
  desc "Fast and secure server for resizing and converting remote images"
  homepage "https://imgproxy.net"
  url "https://github.com/imgproxy/imgproxy/archive/refs/tags/v4.0.11.tar.gz"
  sha256 "9162f28bfe7daebbf3c1c9dbc9c6fc65b715123c24998fb2a635b1d29f910286"
  license "Apache-2.0"
  head "https://github.com/imgproxy/imgproxy.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "aa3108f5fc66d25ec1b3a7cd123db261358a09a41a0b2c3d825396714ad83eb8"
    sha256 cellar: :any, arm64_sequoia: "3dd9debfb609a2cfe9250eb51a7386a000c6cd7ce022848c1d287e99b7f8bd4f"
    sha256 cellar: :any, arm64_sonoma:  "b0647031bcde7ed1f52d354beac8033ba2b4ea3d8abd091f37a4424d1792c061"
    sha256 cellar: :any, sonoma:        "5d9a706e6fddf653c3f01c5217e1233be4b84b86d48e98d570b5aa64d929672a"
    sha256 cellar: :any, arm64_linux:   "1c22394f408551cded7922212152455b6b925f4346f9026523430d0da56459e8"
    sha256 cellar: :any, x86_64_linux:  "81071d61b07b94d341cfb77513c113855409f4dceb272880352e42712e0d733a"
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

    # Workaround to avoid patchelf corruption when cgo is required
    if OS.linux? && Hardware::CPU.arch == :arm64
      ENV["CGO_ENABLED"] = "1"
      ENV["GO_EXTLINK_ENABLED"] = "1"
      ENV.append "GOFLAGS", "-buildmode=pie"
    end

    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cli"
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
