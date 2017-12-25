class Fribidi < Formula
  desc "Implementation of the Unicode BiDi algorithm"
  homepage "https://github.com/fribidi/fribidi"
  url "https://ftp.openbsd.org/pub/OpenBSD/distfiles/fribidi-0.19.7.tar.bz2"
  sha256 "08222a6212bbc2276a2d55c3bf370109ae4a35b689acbc66571ad2a670595a8e"
  revision 1

  bottle do
    cellar :any
    sha256 "328217d2ad90d4f183a44572c59cef7ec0cae37fdfb5b03ace41b37c48d8c72d" => :high_sierra
    sha256 "5d1e95fc89934750643b1a684cd6738839ecc2d05721282dcf72b9c3481092fd" => :sierra
    sha256 "6ba76553f8ec26d4de32e84ce0a99e758d1bb5b7272ac2a985ff71322957d1ac" => :el_capitan
    sha256 "e414b99827d9a472609639ab5030bf5344077763bc178ce743a082008874f232" => :yosemite
    sha256 "70caed8cb2f44044c41e0b91c2645111b9f177d98b4d49cef01fb0d8558c0f98" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "pcre"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--with-glib", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.input").write <<~EOS
      a _lsimple _RteST_o th_oat
    EOS

    assert_match /a simple TSet that/, shell_output("#{bin}/fribidi --charset=CapRTL --test test.input")
  end
end
