class Libewf < Formula
  desc "Library for support of the Expert Witness Compression Format"
  homepage "https://github.com/libyal/libewf"
  url "https://deb.debian.org/debian/pool/main/libe/libewf/libewf_20140608.orig.tar.gz"
  version "20140608"
  sha256 "d14030ce6122727935fbd676d0876808da1e112721f3cb108564a4d9bf73da71"
  revision 3

  bottle do
    cellar :any
    sha256 "4f3520882d014c9ee35a8b32587a4ae13f342d19c7351b22395ca123957dc2f2" => :mojave
    sha256 "0a8e82d0e066e4d53107ed9091786e8ad6887b6f70ecd3fdd46ac1d7fea444d5" => :high_sierra
    sha256 "d2d9c4ee449899af01012fb4c20a1518003fe6f61c0749bdcaebb64c4aa72950" => :sierra
  end

  head do
    url "https://github.com/libyal/libewf.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"

  def install
    if build.head?
      system "./synclibs.sh"
      system "./autogen.sh"
    end

    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --with-libfuse=no
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ewfinfo -V")
  end
end
