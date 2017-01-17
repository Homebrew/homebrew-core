class AptDater < Formula
  desc "Manage package updates on remote hosts using SSH"
  homepage "https://github.com/DE-IBH/apt-dater"
  url "https://github.com/DE-IBH/apt-dater/archive/v0.9.0.tar.gz"
  sha256 "1c361dd686d66473b27db4af8d241d520535c5d5a33f42a35943bf4e16c13f47"

  bottle do
    rebuild 1
    sha256 "49bb3d854aaf984fcc9da2aed057d98edd56b9383425f4a800e22e2513765132" => :sierra
    sha256 "b80cb29f55c78f6a3089001f35f282d539249f80cb2ffacb332f5194c9bbb112" => :el_capitan
    sha256 "5ab44ab078c14e21529949901f62a170157f97b50e702191299453763ff717f3" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "popt"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "AM_LDFLAGS=", "install"
  end

  test do
    system "#{bin}/apt-dater", "-v"
  end
end
