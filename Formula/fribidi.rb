class Fribidi < Formula
  desc "Implementation of the Unicode BiDi algorithm"
  homepage "https://github.com/fribidi/fribidi"
  url "https://github.com/fribidi/fribidi/releases/download/v1.0.1/fribidi-1.0.1.tar.bz2"
  sha256 "c1b182d70590b6cdb5545bab8149de33b966800f27f2d9365c68917ed5a174e4"

  bottle do
    cellar :any
    rebuild 1
    sha256 "c0eba31658f4a732083f3af7a83f0ca59474e7197a81b76b9516c5a7b669a556" => :high_sierra
    sha256 "91f0e573d0cb0af01e46e9ebdc25b04e3d1d5ffc427aebbb51f609819391fa01" => :sierra
    sha256 "b99afe046883119dd1e1646297d67efb31e7981eb13ea4b1678718f9cce711cf" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "pcre"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--with-glib", "--enable-static", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.input").write <<~EOS
      a _lsimple _RteST_o th_oat
    EOS

    assert_match /a simple TSet that/, shell_output("#{bin}/fribidi --charset=CapRTL --test test.input")
  end
end
