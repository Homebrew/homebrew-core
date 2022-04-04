class Ddcutil < Formula
  desc "Control monitor settings using DDC/CI and USB"
  homepage "https://www.ddcutil.com"
  url "https://www.ddcutil.com/tarballs/ddcutil-1.2.2.tar.gz"
  sha256 "822faa342b0bcbb41f15c1910a2bc9d50ffd78f695d6dd04387964010b69cba1"
  license "GPL-2.0-or-later"

  depends_on "glib"
  depends_on "i2c-tools"
  depends_on "kmod"
  depends_on "libdrm"
  depends_on "libusb"
  depends_on "libxrandr"
  depends_on :linux
  depends_on "systemd"

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make"
    system "make", "install"
  end

  test do
    assert_match "The following tests probe the runtime environment using \
multiple overlapping methods.", shell_output("#{bin}/ddcutil environment")
  end
end
