class Lbzip2 < Formula
  desc "Parallel bzip2 utility"
  homepage "https://github.com/kjn/lbzip2"
  url "https://web.archive.org/web/20170304050514/archive.lbzip2.org/lbzip2-2.5.tar.bz2"
  mirror "https://fossies.org/linux/privat/lbzip2-2.5.tar.bz2"
  sha256 "eec4ff08376090494fa3710649b73e5412c3687b4b9b758c93f73aa7be27555b"

  bottle do
    cellar :any_skip_relocation
    sha256 "e9a936e34f1b42f2b7c57deb4eebfa76ee9dd8967960fad81babef5ac8f23867" => :mojave
    sha256 "d297c1d65f6d255c8fec3afa0b79b9b24e92b5462f47673ba8950a8c81a06b90" => :high_sierra
    sha256 "e30a2f0d1bb044183857ea0f6c0b314f97b66b800916f71c0788cbdcf58fcdbc" => :sierra
    sha256 "91c1fb0593205365ff4ada30a34fe7f3afcb1c4e684a3bf239e9168d9fdfc4f7" => :el_capitan
    sha256 "983c8fe1c23dbfdb73d9e7320e776521c4998169a2d17cd1c6f3035674d8a147" => :yosemite
    sha256 "7e521c70fadae71ad2e7807cc844183c05751e4a2433d9f1210069fb2a34333e" => :mavericks
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"

    system "make", "install"
  end

  test do
    touch "fish"
    system "#{bin}/lbzip2", "fish"
    system "#{bin}/lbunzip2", "fish.bz2"
  end
end
