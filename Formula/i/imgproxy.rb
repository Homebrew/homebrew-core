class Imgproxy < Formula
  desc "Fast and secure server for resizing and converting remote images"
  homepage "https://imgproxy.net"
  url "https://github.com/imgproxy/imgproxy/archive/refs/tags/v3.31.2.tar.gz"
  sha256 "e166959eae959e315ead91db4ef9af3f9c095e7ef1fd7cf25c0ea03d2aba25e0"
  license "MIT"
  head "https://github.com/imgproxy/imgproxy.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1fd3784f66902e0c264dd75619c554cc1ab1d9d8fd62fc2583225966a6193773"
    sha256 cellar: :any,                 arm64_sequoia: "214de1d00edce9105398cae340a3053d0bf702ca17b4c9316f32cc03290cfb18"
    sha256 cellar: :any,                 arm64_sonoma:  "a3c0e4ffb7a1865e5683dc9dcbbea357e17667c1608aab2ac3a4e5850e245636"
    sha256 cellar: :any,                 sonoma:        "1f94e56a6ff7b7c2a24cc05a8d683679ac6949d7b6493a0c1f79d71f27ed3a2e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "857fc010b35f6f6168f035b492dcbbea1d1b06e11d4a57042c7d24e59bb0b0b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "db33b747ea48b192ac198232387d82ed52cea6150c60cee01c421034d092cd8e"
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
