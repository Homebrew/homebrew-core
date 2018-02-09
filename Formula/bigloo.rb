class Bigloo < Formula
  desc "Scheme implementation with object system, C, and Java interfaces"
  homepage "https://www-sop.inria.fr/indes/fp/Bigloo/"
  url "ftp://ftp-sop.inria.fr/indes/fp/Bigloo/bigloo4.3b.tar.gz"
  version "4.3b"
  sha256 "5c6c864ebc9bce6d6f768da912e3cd099256ebb08c38c69f3181f71a7d424b55"

  bottle do
    sha256 "1b6fce918e35cc37fb6e2c9d10f36b48866cdeaa577026114ff533efc72fb361" => :high_sierra
    sha256 "5aef2cf4b59096ddc38cf12698543f18a68b784aa0b12beefb646334c3a89ef4" => :sierra
    sha256 "41947394e3272672e20f2980e4bfbad317fcdaced331d9478322550cc8cd9024" => :el_capitan
  end

  option "with-jvm", "Enable JVM support"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  depends_on "openssl"
  depends_on "gmp" => :recommended

  fails_with :clang do
    build 500
    cause <<~EOS
      objs/obj_u/Ieee/dtoa.c:262:79504: fatal error: parser
      recursion limit reached, program too complex
    EOS
  end

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --mandir=#{man1}
      --infodir=#{info}
      --customgc=yes
      --os-macosx
      --native=yes
      --disable-alsa
      --disable-mpg123
      --disable-flac
    ]

    args << "--jvm=yes" if build.with? "jvm"
    args << "--no-gmp" if build.without? "gmp"

    # SRFI 27 is 32-bit only
    args << "--disable-srfi27" if MacOS.prefer_64_bit?

    system "./configure", *args

    # bigloo seems to either miss installing these dependencies, or maybe
    # do it out of order with where they're used.
    cd "libunistring" do
      system "make", "install"
    end
    cd "pcre" do
      system "make", "install"
    end

    system "make"
    system "make", "install"

    # Install the other manpages too
    manpages = %w[bgldepend bglmake bglpp bgltags bglafile bgljfile bglmco bglprof]
    manpages.each { |m| man1.install "manuals/#{m}.man" => "#{m}.1" }
  end

  test do
    program = <<~EOS
      (display "Hello World!")
      (newline)
      (exit)
    EOS
    assert_match "Hello World!\n", pipe_output("#{bin}/bigloo -i -", program)
  end
end
