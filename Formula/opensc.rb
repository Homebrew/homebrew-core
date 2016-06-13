class Opensc < Formula
  desc "Tools and libraries for smart cards"
  homepage "https://github.com/OpenSC/OpenSC/wiki"
  url "https://github.com/OpenSC/OpenSC/releases/download/0.16.0/opensc-0.16.0.tar.gz"
  sha256 "3ac8c29542bb48179e7086d35a1b8907a4e86aca3de3323c2f48bd74eaaf5729"
  head "https://github.com/OpenSC/OpenSC.git"

  bottle do
    revision 2
    sha256 "b84361bf93572c5b156e5e722408ad88f94ecb76ff5703ad731300cc2bf4a59d" => :el_capitan
    sha256 "68c918cc0aa1660dd91ed127b3d0dcc07a0ce4001cbdb530904b4aec04c6d48b" => :yosemite
    sha256 "def6a8fa98e04884692da8e0c01043b861c4879becb7a773b1321c2374b019d7" => :mavericks
  end

  option "without-man-pages", "Skip building manual pages"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "docbook-xsl" => :build if build.with? "man-pages"
  depends_on "openssl"

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-sm
      --enable-openssl
      --enable-pcsc
    ]

    if build.with? "man-pages"
      args << "--with-xsl-stylesheetsdir=#{Formula["docbook-xsl"].opt_prefix}/docbook-xsl"
    end

    system "./bootstrap"
    system "./configure", *args
    system "make", "install"
  end
end
