class Potrace < Formula
  desc "Convert bitmaps to vector graphics"
  homepage "https://potrace.sourceforge.io/"
  url "https://potrace.sourceforge.io/download/1.15/potrace-1.15.tar.gz"
  sha256 "a9b33904ace328340c850a01458199e0064e03ccaaa731bc869a842b1b8d529d"

  bottle do
    cellar :any
    sha256 "b71fa6c507b43df9e48dc0259e5dfb803a13c9728ffd6978b9798d03da363e0d" => :sierra
    sha256 "318e2448e2596b9629537edc4e5c408ea4e1f538ec6f1d90b17589aced9836ff" => :el_capitan
    sha256 "dad163b773ea01123ccefc6a9ddba7d02c234fe384a9a41e6029887c319ececc" => :yosemite
  end

  resource "head.pbm" do
    url "https://potrace.sourceforge.io/img/head.pbm"
    sha256 "3c8dd6643b43cf006b30a7a5ee9604efab82faa40ac7fbf31d8b907b8814814f"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--with-libpotrace"
    system "make", "install"
  end

  test do
    resource("head.pbm").stage testpath
    system "#{bin}/potrace", "-o", "test.eps", "head.pbm"
    assert File.exist? "test.eps"
  end
end
