class Potrace < Formula
  desc "Convert bitmaps to vector graphics"
  homepage "https://potrace.sourceforge.io/"
  url "https://potrace.sourceforge.io/download/1.15/potrace-1.15.tar.gz"
  sha256 "a9b33904ace328340c850a01458199e0064e03ccaaa731bc869a842b1b8d529d"

  bottle do
    cellar :any
    sha256 "464057e611c3715cad4698b2acfd3a1cd809dd3fceb172b3003ccbb9c16309c0" => :catalina
    sha256 "3d25cc97a832eb016be11e133d0196308b0b3dd21b2f62302215ba566ee77399" => :mojave
    sha256 "f98e3daaed06c6296d446c53087b82a7e100eb3407d41075e706e66327c26f95" => :high_sierra
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
    assert_predicate testpath/"test.eps", :exist?
  end
end
