class Opensc < Formula
  desc "Tools and libraries for smart cards"
  homepage "https://github.com/OpenSC/OpenSC/wiki"
  revision 1
  head "https://github.com/OpenSC/OpenSC.git"

  stable do
    url "https://github.com/OpenSC/OpenSC/releases/download/0.16.0/opensc-0.16.0.tar.gz"
    sha256 "3ac8c29542bb48179e7086d35a1b8907a4e86aca3de3323c2f48bd74eaaf5729"

    # Can be removed for next release: https://github.com/Homebrew/homebrew-core/issues/5338
    patch do
      url "https://github.com/OpenSC/OpenSC/commit/2746a7f430cb02fbd21cf9c2f0819124e6adca76.diff"
      sha256 "0e39427cb9430971be70cdde3ae57aa10fb0f7fe0acea35bf066d8a651873270"
    end
  end

  bottle do
    sha256 "b3f2e064e807dcabaf847e89c8a66f4c1b2d0258f481bc8351faa862e6f50bef" => :sierra
    sha256 "88e03e589902a65e99c085bac993fef782a3e5011757b330f98d1984a195ff42" => :el_capitan
    sha256 "68f04600dd085c6720559b78ea8387f40ed7045fa4c281beedb13faa6545fdc0" => :yosemite
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
