class Ddcutil < Formula
  desc "Control monitor settings using DDC/CI and USB"
  homepage "https://www.ddcutil.com"
  url "https://www.ddcutil.com/tarballs/ddcutil-1.4.0.tar.gz"
  sha256 "46091750c1739dd7ec92f25b39794560ecc74f0faa5a67bda7ed8bff2008bf47"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.ddcutil.com/releases/"
    regex(/href=.*?ddcutil[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "df4a31ba6fdbead2533760c2f14709230398d377d833fe93ebdfb810f73c1f63"
  end

  depends_on "pkg-config" => :build
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
