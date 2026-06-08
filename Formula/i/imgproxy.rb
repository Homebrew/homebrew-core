class Imgproxy < Formula
  desc "Fast and secure server for resizing and converting remote images"
  homepage "https://imgproxy.net"
  url "https://github.com/imgproxy/imgproxy/archive/refs/tags/v4.0.3.tar.gz"
  sha256 "8cd18c13a85d5c05c912cae5b3641a606ce2ca0bf70ef5c2ed26dcadcefd7f31"
  license "Apache-2.0"
  head "https://github.com/imgproxy/imgproxy.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7716ecdb680c80bed913ee4c8440d64e0fa88debb86f76a29cf08ca0dc093b58"
    sha256 cellar: :any,                 arm64_sequoia: "b549c67f81689e7e1e126c0401272ab0166efef731874d4e0881fc7bcfcc7f9e"
    sha256 cellar: :any,                 arm64_sonoma:  "a1963c13218db6e9e405751614cd0fbce29dae70a962e0043b8e3d73aeea0664"
    sha256 cellar: :any,                 sonoma:        "e2088991fe7e7b9290a24e0d3f3ad20ea3b1b5160ddbf6deb7debd51f3a5f767"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "293e77d43390e971745ef91ac785d1468548e60e0a51475a3cd8452b82b46ded"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b01262c1d5564a1fa4a42d46d6d6cb45ebe2f8186f9587b97e3c404c0785b5e3"
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
