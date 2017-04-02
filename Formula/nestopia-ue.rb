class NestopiaUe < Formula
  desc "Nestopia UE (Undead Edition): NES emulator"
  homepage "http://0ldsk00l.ca/nestopia/"
  url "https://downloads.sourceforge.net/project/nestopiaue/1.47/nestopia-1.47.tgz"
  sha256 "84624d30ab05d609db2734db0065616b268f79d4aa35f1cd90cb35ee8d96be0c"
  head "https://github.com/rdanbrook/nestopia.git"

  bottle do
    sha256 "2246c47a836949e3f166f3a8aaa01aeececcbdcea367e1e8bc1c884beb628f01" => :sierra
    sha256 "9c6c71062aa1d665de3660c9926811444a9647be01aa7ba08dce7eda7f8f11fc" => :el_capitan
    sha256 "24af85a335612e9da798ac15aa0d37375336e6d52e1ee173a40cd0b276e6fc82" => :yosemite
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
