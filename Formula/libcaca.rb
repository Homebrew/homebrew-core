class Libcaca < Formula
  desc "Convert pixel information into colored ASCII art"
  homepage "http://caca.zoy.org/wiki/libcaca"
  url "http://caca.zoy.org/files/libcaca/libcaca-0.99.beta19.tar.gz"
  mirror "https://www.mirrorservice.org/sites/distfiles.macports.org/libcaca/libcaca-0.99.beta19.tar.gz"
  mirror "https://fossies.org/linux/privat/libcaca-0.99.beta19.tar.gz"
  version "0.99b19"
  sha256 "128b467c4ed03264c187405172a4e83049342cc8cc2f655f53a2d0ee9d3772f4"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "5fdae59a6182939b56e6b332d0671f377a2935ee14d29f630a35319000320d1e" => :mojave
    sha256 "4dea1c7b81fa8ca381cd402230de959fd5c4225a890c528c615563012364b076" => :high_sierra
    sha256 "728b8bb277ef92bdf90f91ce445c7b8f1259db898a33ae36b4de9988b786de47" => :sierra
    sha256 "ba475a145203197f637059f20dfcb5d8cfb34615ce30bfe342fbe7887ebcad41" => :el_capitan
    sha256 "1d02b3264c1665a8f6af5d88ba944bc1009ee7e553ae8decfff89615b7dc79d9" => :yosemite
    sha256 "511f48aa84b45eb509de89296102517bd77c25347999cf1d733bc8593c95a00b" => :mavericks
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
