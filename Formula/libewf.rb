class Libewf < Formula
  desc "Library for support of the Expert Witness Compression Format"
  homepage "https://github.com/libyal/libewf"
  # The main libewf repository is currently "experimental".
  url "https://github.com/libyal/libewf-legacy/releases/download/20140808/libewf-20140808.tar.gz"
  sha256 "dfe29b5f2f1841ff1fe11979780d710a660dbc4727af82ec391f398e6b49e5fd"

  bottle do
    cellar :any
    sha256 "e2c5005bc71cf22e1aa33ab1c9b4e816660e1b1085a79251455365b8b48bb139" => :catalina
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

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

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
