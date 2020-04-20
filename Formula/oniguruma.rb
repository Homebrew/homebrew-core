class Oniguruma < Formula
  desc "Regular expressions library"
  homepage "https://github.com/kkos/oniguruma/"
  url "https://github.com/kkos/oniguruma/releases/download/v6.9.5/onig-6.9.5.tar.gz"
  sha256 "2f25cc3165e6da4b12dcabdb6b77c48f436d835e127ec2e3cad7abae9ea8e9a6"
  head "https://github.com/kkos/oniguruma.git"

  bottle do
    cellar :any
    sha256 "05e25bc53db0cf338a7f765da76c66260972d6b4e259be415bc17807a8b60fe9" => :catalina
    sha256 "ab2bb92e40e17569c54dda0ed3b3a0fc6f98be761107fba918754af75817de6f" => :mojave
    sha256 "1a97b801983a8929de40bcc829d50e3f37413dbb7076370e203deff76dad4357" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "autoreconf", "-vfi"
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match(/#{prefix}/, shell_output("#{bin}/onig-config --prefix"))
  end
end
