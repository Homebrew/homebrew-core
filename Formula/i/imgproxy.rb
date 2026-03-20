class Imgproxy < Formula
  desc "Fast and secure server for resizing and converting remote images"
  homepage "https://imgproxy.net"
  url "https://github.com/imgproxy/imgproxy/archive/refs/tags/v3.31.1.tar.gz"
  sha256 "3637668e56dc154a7abb86c740dd205acf679ef7ae5c0372d4dfd375a4357f95"
  license "MIT"
  head "https://github.com/imgproxy/imgproxy.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8ba11c867410f00f9894fac05102d7741bbdb85dc69ef97303d25793d25bf778"
    sha256 cellar: :any,                 arm64_sequoia: "f5b1f85cfaec72153ee696a61cae35b0b3cf9d6260b85c5f9a33c3ac4d8821f8"
    sha256 cellar: :any,                 arm64_sonoma:  "dc1b98d0610f96e4b1bc5a687f8515146fd359294ffb0f7003d022db830c4cc3"
    sha256 cellar: :any,                 sonoma:        "a45150e2d7cb97d9343f8c8e9fdfd3804e55873b13a1caaf8e380dc624156f7b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a7e72ca7ca44fdc43c9ac293a00ab42c6284d305ca00c530e787cd099f917cac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a1c2b7307ab861c75c42311822486f954aa54a81114342b675283f9a4f62ab7"
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
