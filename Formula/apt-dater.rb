class AptDater < Formula
  desc "Manage package updates on remote hosts using SSH"
  homepage "https://github.com/DE-IBH/apt-dater"
  url "https://github.com/DE-IBH/apt-dater/archive/v0.9.0.tar.gz"
  sha256 "1c361dd686d66473b27db4af8d241d520535c5d5a33f42a35943bf4e16c13f47"
  version_scheme 1

  bottle do
    rebuild 2
    sha256 "ee24c55759d197401d4b4c930837c48a5343edf1ed9bb308c7fdedde2be19cd8" => :mojave
    sha256 "2263ba095d1b5250428fd765b4c591886a4f7c117b1bb62719df1033a246de32" => :high_sierra
    sha256 "026b29a9428c2c1d77e70001c8651f8e8ac20b20dee1ba62a89e0d69e2da570e" => :sierra
    sha256 "a2f37094132e6f5cd8ad9b287bf299eea8acbc99b1d468002dfe875a8a14985d" => :el_capitan
    sha256 "2ac3ba56f32d018a9af477484d8ad561871f855aca78726dbe8f43f5552f6acc" => :yosemite
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
