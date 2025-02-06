class Imgproxy < Formula
  desc "Fast and secure server for resizing and converting remote images"
  homepage "https://imgproxy.net"
  url "https://github.com/imgproxy/imgproxy/archive/refs/tags/v3.27.2.tar.gz"
  sha256 "e9500cc11a87c63c558200f7dc21537ebb0e8ac4dbb55894af99ff5e7a188484"
  license "MIT"
  head "https://github.com/imgproxy/imgproxy.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "602d2555295d92c113645a1d34871601febab273a303a1d3c28f6456f00e0a68"
    sha256 cellar: :any,                 arm64_sonoma:  "1cdde718e93ef4aae2fc503bddfc6aacce825157d98b059367c5140d7dd4dba2"
    sha256 cellar: :any,                 arm64_ventura: "7946e608c15d41f5f4773d2423b91c1d8ee398b9173c9ea2562ec39a43054df2"
    sha256 cellar: :any,                 sonoma:        "e5aeae8a891f654f0333928991486b2ab621719676159482249fd75aba8f9c75"
    sha256 cellar: :any,                 ventura:       "3a9c4941687a9b6dc31893f0dd3f044a5cc2fadbc54cfbe7d44756f7be95a47e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "35c810c7b1b4a6517672ae0f603b18d3ee0419593c72f487c53a0c584e49830a"
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
