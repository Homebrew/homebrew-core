class Imgproxy < Formula
  desc "Fast and secure server for resizing and converting remote images"
  homepage "https://imgproxy.net"
  url "https://github.com/imgproxy/imgproxy/archive/refs/tags/v3.31.3.tar.gz"
  sha256 "bd01ae3f0c800ef6c7f6bcf879d919e14d98a65439c54972d8bc30c9bccce6aa"
  license "MIT"
  head "https://github.com/imgproxy/imgproxy.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f72239fa74690b1b71ae7bdd39f9985d06e0c7acb520dc8f618320df82188406"
    sha256 cellar: :any,                 arm64_sequoia: "04623950f6589e69bf52ba26907c5da68a549b93d8442e96517a595d22b01262"
    sha256 cellar: :any,                 arm64_sonoma:  "b0af62bee29d1e89c763021823928297c91eafde4db82785e893ca02263bc978"
    sha256 cellar: :any,                 sonoma:        "4a538d37a5920dbb59ea5653e4e4e8dc963ab8a21080c232588a6d2dbb70eba9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "54fed4133baf59a7dea57e8544830b8989ed0e93a60ad15e7f3d15dfdf8f1868"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9def25a5be8fc77de95ad90a5040c8d8b5eca0e160469faa36c05527de9469bc"
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
