class Hebcal < Formula
  desc "Perpetual Jewish calendar for the command-line"
  homepage "https://github.com/hebcal/hebcal"
  url "https://github.com/hebcal/hebcal/archive/v4.21.tar.gz"
  sha256 "6295bc183d8a9694f2546100909fb0b1943f0acc55c9743937f435f17d47ddbc"
  license "GPL-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "d9a509892c033c03341ea04daa4c763818653ebb4e0d921cd67784c9d6aeae74" => :catalina
    sha256 "ff1b1f27fcaeb762bbff51f7dce52d874d439680eb11de2ab867fb3f08682322" => :mojave
    sha256 "219e4100f05a5c856781d0d85e091327453fffd69140ecaa318ef27eb904ec4a" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    system "./configure", "--prefix=#{prefix}", "ACLOCAL=aclocal", "AUTOMAKE=automake"
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/hebcal 01 01 2020").chomp
    assert_equal output, "1/1/2020 4th of Tevet, 5780"
  end
end
