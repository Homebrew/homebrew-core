class Hfstospell < Formula
  desc "Helsinki Finite-State Technology ospell"
  homepage "https://hfst.github.io/"
  url "https://github.com/hfst/hfst-ospell/releases/download/v0.5.0/hfstospell-0.5.0.tar.gz"
  sha256 "0fd2ad367f8a694c60742deaee9fcf1225e4921dd75549ef0aceca671ddfe1cd"
  revision 1

  bottle do
    cellar :any
    sha256 "95c814064c7b4bc104615012aff09ea75e94ab90cc20a8d99ff6cfcfc001ac2d" => :high_sierra
    sha256 "108d56228651e0157480ceaa1b20de5bc27a0144af366df35526ef162a1ff987" => :sierra
    sha256 "97f005a6947c53c562232b2a3b83f39e1ba544f0befe8df3a8cc418678804fdf" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "icu4c"
  depends_on "libarchive"
  depends_on "libxml++"

  needs :cxx11

  def install
    # icu4c 61.1 compatability
    ENV.append "CPPFLAGS", "-DU_USING_ICU_NAMESPACE=1"

    ENV.cxx11
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/hfst-ospell", "--version"
  end
end
