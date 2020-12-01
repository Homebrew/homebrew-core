class Libcaca < Formula
  desc "Convert pixel information into colored ASCII art"
  homepage "http://caca.zoy.org/wiki/libcaca"
  url "http://caca.zoy.org/files/libcaca/libcaca-0.99.beta19.tar.gz"
  mirror "https://www.mirrorservice.org/sites/distfiles.macports.org/libcaca/libcaca-0.99.beta19.tar.gz"
  mirror "https://fossies.org/linux/privat/libcaca-0.99.beta19.tar.gz"
  version "0.99b19"
  sha256 "128b467c4ed03264c187405172a4e83049342cc8cc2f655f53a2d0ee9d3772f4"
  license "WTFPL"
  revision 3

  # The regex here matches unstable releases and is loose about it (`.*`), as
  # there are currently only beta releases and we don't know if there will be
  # releases candidates, etc. before there's a stable release. Hopefully we can
  # restrict this to stable releases in the future but it has to be loose for
  # the moment.
  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+.*)/i)
  end

  bottle do
    cellar :any
    sha256 "b05fb9698cfdc95696c1fa80d9b72fabd2a45372de83116f61707d7bff1cb38b" => :big_sur
    sha256 "621026d8276dd31c1464ed1fd688aac04841336b6e686ee122b9cc760a8a255f" => :catalina
    sha256 "7474fbf03e949d693c4ac8f601df4b40baa05094491438d7e2ce77df1e974d58" => :mojave
  end

  head do
    url "https://github.com/cacalabs/libcaca.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "imlib2"

  def install
    system "./bootstrap" if build.head?

    # Fix --destdir issue.
    #   ../.auto/py-compile: Missing argument to --destdir.
    inreplace "python/Makefile.in",
              '$(am__py_compile) --destdir "$(DESTDIR)"',
              "$(am__py_compile) --destdir \"$(cacadir)\""

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --disable-doc
      --disable-slang
      --disable-java
      --disable-csharp
      --disable-ruby
      --disable-x11
    ]

    system "./configure", *args
    system "make"
    ENV.deparallelize # Or install can fail making the same folder at the same time
    system "make", "install"
  end

  test do
    system "#{bin}/img2txt", "--version"
  end
end
