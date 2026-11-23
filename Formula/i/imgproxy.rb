class Imgproxy < Formula
  desc "Fast and secure server for resizing and converting remote images"
  homepage "https://imgproxy.net"
  url "https://github.com/imgproxy/imgproxy/archive/refs/tags/v4.0.25.tar.gz"
  sha256 "816a19a07e1a835854d34982f0a5ec70406fbe97e04679b244198c1deb6377cc"
  license "Apache-2.0"
  head "https://github.com/imgproxy/imgproxy.git", branch: "master"

  bottle do
    manifest_sha256 "9e5327eebec82360d93cc931abe1d3bd4ad21da097b71ab04b2d34aee2189c3f"
    sha256 cellar: :any, arm64_golden_gate: "4ffc9858eb4ebd187886636c32cd4ac77dd118a8f3fbe598440c96498a6cdcda"
    sha256 cellar: :any, arm64_tahoe:       "36f88186ec0d1b59d9a2b974e61c402f2b11356892d7daef41bc30859949421c"
    sha256 cellar: :any, arm64_sequoia:     "98ed932d6e76bbcf4761fdff9d983ce5dc2215cd97587573ac5b707dacee211a"
    sha256 cellar: :any, arm64_linux:       "6bfc03d713bbd341e7d41ce1540092d14c03e30a7e1bf38bd1cb1ad6fc211b60"
    sha256 cellar: :any, x86_64_linux:      "75dd069322c14d3b277a43fa305f2c1da0e0b70b424fe767c0c78df48198a6ab"
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
    if OS.linux? && Hardware::CPU.arm64?
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

    with_test_process(bin/"imgproxy") do
      sleep 20

      output = testpath/"test-converted.png"
      url = "http://127.0.0.1:#{port}/insecure/resize:fit:100:100:true/plain/local:///test.jpg@png"

      system "curl", "-s", "-o", output, url
      assert_path_exists output

      file_output = shell_output("file #{output}")
      assert_match "PNG image data", file_output
      assert_match "100 x 100", file_output
    end
  end
end
