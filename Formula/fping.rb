class Fping < Formula
  desc "Scriptable ping program for checking if multiple hosts are up"
  homepage "https://fping.org/"
  url "https://fping.org/dist/fping-4.1.tar.gz"
  sha256 "2733e2a18cc2b5b935c4e3b5b84ccf2080c38043f1864d7c43326e8048ddab73"

  bottle do
    cellar :any_skip_relocation
    sha256 "0ccb78b1ee2a43b5742bbdc65c8113681ed264365c547e36449435464e24b135" => :mojave
    sha256 "1a97d2982df8c7c3561ee1f50206c91fb9674c732e41c71e29ab28279f5ed312" => :high_sierra
    sha256 "6150a9003ce556789a252dc3fa73c6125b392887f35fe4a313cda41e74071342" => :sierra
  end

  head do
    url "https://github.com/schweikert/fping.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sbindir=#{bin}"
    system "make", "install"
  end

  test do
    assert_equal "::1 is alive", shell_output("#{bin}/fping -A localhost").chomp
  end
end
