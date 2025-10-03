class Ddcutil < Formula
  desc "Control monitor settings using DDC/CI and USB"
  homepage "https://www.ddcutil.com"
  url "https://www.ddcutil.com/tarballs/ddcutil-2.2.1.tar.gz"
  sha256 "71c8760c383dd5fa21817839b86b9850ac6d558e133e2d6fea88dfaf04448ae6"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.ddcutil.com/releases/"
    regex(/href=.*?ddcutil[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "82dbb304e63bb4f56aca9c3dc86655d39970e2923d079ce64323e169e36d0866"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "d298710ca164306270b140ff563533ed29feabc306dadb2d345ed5968a720d4c"
  end

  depends_on "pkgconf" => :build
  depends_on "glib"
  depends_on "i2c-tools"
  depends_on "jansson"
  depends_on "kmod"
  depends_on "libdrm"
  depends_on "libusb"
  depends_on "libx11"
  depends_on "libxext"
  depends_on "libxrandr"
  depends_on :linux
  depends_on "systemd"

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    assert_match "The following tests probe the runtime environment using multiple overlapping methods.",
      shell_output("#{bin}/ddcutil environment")
  end
end
