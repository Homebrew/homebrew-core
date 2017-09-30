class Libsmi < Formula
  desc "Library to Access SMI MIB Information"
  homepage "https://www.ibr.cs.tu-bs.de/projects/libsmi/"
  url "https://www.ibr.cs.tu-bs.de/projects/libsmi/download/libsmi-0.5.0.tar.gz"
  sha256 "f21accdadb1bb328ea3f8a13fc34d715baac6e2db66065898346322c725754d3"

  bottle do
    rebuild 1
    sha256 "d28353ef2fc8bd3d521dc989e99a72e7caffd0890d5056cfea702e9b7ff57588" => :high_sierra
    sha256 "8a77bfffacfce5c323970f1ae870e62ba577964f743721e62583b4713001bc20" => :sierra
    sha256 "27cffaf7b38a36a1da50661a3a7a243fd9aaecaa73e4a91a462155a553a17f52" => :el_capitan
    sha256 "6d30614b5a664f046bb3777b0bf0c04fbadb2203edffc9275d34ab3d50e3dc6d" => :yosemite
    sha256 "468714d42c8aa845d2c53de783b43753d99fcca7ee5f0b8fd4726fbdb1a0299c" => :mavericks
    sha256 "29c960c1a37c4dbe51fe87634db55b888211d22061db9a668e4c116887e04ca9" => :mountain_lion
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
