class Imgproxy < Formula
  desc "Fast and secure server for resizing and converting remote images"
  homepage "https://imgproxy.net"
  url "https://github.com/imgproxy/imgproxy/archive/refs/tags/v4.0.13.tar.gz"
  sha256 "4856865b2fe70058cfcfb993388251535977d30abeb65c50af613c40cbac8a31"
  license "Apache-2.0"
  head "https://github.com/imgproxy/imgproxy.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "ace199ead346d80c11a30a238d7030864019d6fbf59b34c92d5d91cd466c79b9"
    sha256 cellar: :any, arm64_sequoia: "d65ce29d21e24a8198e255591d333923f2b5832181c74c6a37fc3f16ff117c83"
    sha256 cellar: :any, arm64_sonoma:  "bc222974efa28875fe77ca5c10c3c63b7376d4cb9f1860f05c31cd54b2f13c6e"
    sha256 cellar: :any, sonoma:        "04c1011a2981d79ded38ab06f9e8f9a6523aaf6d164b9cb42f08ba131109ae4c"
    sha256 cellar: :any, arm64_linux:   "39da384718c942afe21329722c8e88d2de417c826a6152562770d98713faec78"
    sha256 cellar: :any, x86_64_linux:  "6f2c5853db117abe4c163fd5d5695060b232ce370c25cc2f11e934e9da621996"
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

    system "go", "build", *std_go_args, "./cli"
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
