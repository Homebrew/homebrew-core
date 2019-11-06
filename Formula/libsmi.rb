class Libsmi < Formula
  desc "Library to Access SMI MIB Information"
  homepage "https://www.ibr.cs.tu-bs.de/projects/libsmi/"
  url "https://www.ibr.cs.tu-bs.de/projects/libsmi/download/libsmi-0.5.0.tar.gz"
  mirror "https://www.mirrorservice.org/sites/distfiles.macports.org/libsmi/libsmi-0.5.0.tar.gz"
  sha256 "f21accdadb1bb328ea3f8a13fc34d715baac6e2db66065898346322c725754d3"

  bottle do
    cellar :any
    rebuild 1
    sha256 "1a25b44883bb95940e789ec6395dfa796ec44fd4e0d9ae1ee81a4119fe70ac14" => :catalina
    sha256 "507d7f52bd7be5c1cc3170831de43e3ebd5a4312b6eda5d795d7519437016246" => :mojave
    sha256 "25a31cf7557ddfc1174a932b904d6c96bda4f3c733caf8258edbdef376e99544" => :high_sierra
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match /#{version}/, shell_output("#{bin}/smidiff -V")
  end
end
