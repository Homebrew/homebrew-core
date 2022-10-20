class Ddcutil < Formula
  desc "Control monitor settings using DDC/CI and USB"
  homepage "https://www.ddcutil.com"
  url "https://www.ddcutil.com/tarballs/ddcutil-1.3.2.tar.gz"
  sha256 "bd923b3aab868d9d24a00add3962a47c5b5f4730afb579bc946142524965a042"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.ddcutil.com/releases/"
    regex(/href=.*?ddcutil[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "df4a31ba6fdbead2533760c2f14709230398d377d833fe93ebdfb810f73c1f63"
  end

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
