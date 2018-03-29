class Hfstospell < Formula
  desc "Helsinki Finite-State Technology ospell"
  homepage "https://hfst.github.io/"
  url "https://github.com/hfst/hfst-ospell/releases/download/v0.5.0/hfstospell-0.5.0.tar.gz"
  sha256 "0fd2ad367f8a694c60742deaee9fcf1225e4921dd75549ef0aceca671ddfe1cd"
  revision 1

  bottle do
    cellar :any
    sha256 "de622d1a6a04d7f4de2525d8717d06e5c5c4c920eac54b86d4a9296966a891e7" => :high_sierra
    sha256 "a15f6eb7855860c888079fcbd7a0e4ee10e52101db5b7923092c0f9883f144ec" => :sierra
    sha256 "70dbedbf094447921f05004f7aac65831e288eda106b633773001d4e68c5f5b4" => :el_capitan
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
