class NestopiaUe < Formula
  desc "Nestopia UE (Undead Edition): NES emulator"
  homepage "http://0ldsk00l.ca/nestopia/"
  url "https://downloads.sourceforge.net/project/nestopiaue/1.47/nestopia-1.47.tgz"
  sha256 "84624d30ab05d609db2734db0065616b268f79d4aa35f1cd90cb35ee8d96be0c"
  head "https://github.com/rdanbrook/nestopia.git"

  bottle do
    sha256 "70c485d2d1cd9dd4aa7cbf78cf2acb532bbc5c90e553a5e00a3d6a112704e7df" => :el_capitan
    sha256 "0cd58c71d243e7adf02761a83d5fb479b5cdf3778cfb023e57dac7fd48c3490d" => :yosemite
    sha256 "e9d6496a8b23a17c1a3a46695e5e41b75a8d08275271fd4e23bbe9ed5b92eb94" => :mavericks
  end

  depends_on "sdl2"
  depends_on "libao"
  depends_on "libarchive"
  depends_on "libepoxy"

  def install
    system "make", "PREFIX=#{prefix}", "DATADIR=#{pkgshare}"
    bin.install "nestopia"
    pkgshare.install "NstDatabase.xml"
  end

  test do
    assert_match /Nestopia UE #{version}$/, shell_output("#{bin}/nestopia --version")
  end
end
