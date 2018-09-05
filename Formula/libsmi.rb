class Libsmi < Formula
  desc "Library to Access SMI MIB Information"
  homepage "https://www.ibr.cs.tu-bs.de/projects/libsmi/"
  url "https://www.ibr.cs.tu-bs.de/projects/libsmi/download/libsmi-0.5.0.tar.gz"
  mirror "https://www.mirrorservice.org/sites/distfiles.macports.org/libsmi/libsmi-0.5.0.tar.gz"
  sha256 "f21accdadb1bb328ea3f8a13fc34d715baac6e2db66065898346322c725754d3"

  bottle do
    sha256 "55de35adc48be4dcba48f6f088841491168de0e7f88e768d2448274c5d81daba" => :mojave
    sha256 "8c1bba9799c48d5b977dafbbd31a61722cb0aea36c478720cbd67a240b3d42cc" => :high_sierra
    sha256 "92f1085c6337464387892efd275acf3b0eba9947a07ff353d4b02e16f912bce4" => :sierra
    sha256 "bf050ac873b082e36bfb280cd2325c00bc679b54be6ece47d0bfd1135ae7a872" => :el_capitan
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
