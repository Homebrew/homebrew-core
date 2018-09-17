class Libquicktime < Formula
  desc "Library for reading and writing quicktime files"
  homepage "https://libquicktime.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/libquicktime/libquicktime/1.2.4/libquicktime-1.2.4.tar.gz"
  sha256 "1c53359c33b31347b4d7b00d3611463fe5e942cae3ec0fefe0d2fd413fd47368"
  revision 4

  bottle do
    rebuild 1
    sha256 "2bd4f42d7ce3fe5201adc32a8a861a6a2dffc3fb9a7aaf8abbdd2e976ef37cfd" => :mojave
    sha256 "aece680a44a90c17ec0302731951e9d6be28e3805faebbcb2c83112051faa621" => :high_sierra
    sha256 "2d5e161d907515618e2a90795803069d0ceec5d2480b1126041706e480349ded" => :sierra
    sha256 "bb90ed12e349973bbc4cfd143718801aa60de918325e1a109dd60b704497faae" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"

  # Fix CVE-2016-2399. Applied upstream on March 6th 2017.
  # Also, fixes from upstream for CVE-2017-9122 through CVE-2017-9128, applied
  # by Debian since 30 Jun 2017.
  patch do
    url "https://mirrors.ocf.berkeley.edu/debian/pool/main/libq/libquicktime/libquicktime_1.2.4-12.debian.tar.xz"
    mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/libq/libquicktime/libquicktime_1.2.4-12.debian.tar.xz"
    sha256 "e5b5fa3ec8391b92554d04528568d04ea9eb5145835e0c246eac7961c891a91a"
    apply "patches/CVE-2016-2399.patch"
    apply "patches/CVE-2017-9122_et_al.patch"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-gpl",
                          "--without-doxygen",
                          "--without-gtk",
                          "--without-x"
    system "make"
    system "make", "install"
  end

  test do
    fixture = test_fixtures("test.m4a")
    output = shell_output("#{bin}/qtinfo #{fixture} 2>&1")
    assert_match "length 1536 samples, compressor mp4a", output
    assert_predicate testpath/".libquicktime_codecs", :exist?
  end
end
