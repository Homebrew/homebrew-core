class Fwup < Formula
  desc "Configurable embedded Linux firmware update creator and runner"
  homepage "https://github.com/fwup-home/fwup"
  url "https://github.com/fwup-home/fwup/releases/download/v1.15.0/fwup-1.15.0.tar.gz"
  sha256 "ad1b0f92dcabe2e417be7eebc5201f05c101cd18baafa43400a00bc7caddddce"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ff02e00ef76a7ef5587fd451ffd2ad55b5ea1e829b0ea5de74efa126833a03da"
    sha256 cellar: :any,                 arm64_sequoia: "8c9eba7a9cc1aa599c52881684985a658b9d728e3fcbf00c6b96cda758a348af"
    sha256 cellar: :any,                 arm64_sonoma:  "809366ff2778ecb69032c200e235e39669cb332b054da0891bffd9f6841eba10"
    sha256 cellar: :any,                 sonoma:        "5e02e0d5a1d719a6dd3ad1d3b393b6920e5a1d77947e6fd166e785f6db656639"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "76f0c332bb56b3bb4421e73cb13a481213f8f062cf0ad11549bf453a0b05c7c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a351a9a471afcaacaf1a9b911a5aca2b9b3d24cd854cb6800ed232694cd6a6c0"
  end

  depends_on "pkgconf" => :build
  depends_on "confuse"
  depends_on "libarchive"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"fwup", "-g"
    assert_path_exists testpath/"fwup-key.priv", "Failed to create fwup-key.priv!"
    assert_path_exists testpath/"fwup-key.pub", "Failed to create fwup-key.pub!"
  end
end
