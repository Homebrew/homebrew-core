class Bigloo < Formula
  desc "Scheme implementation with object system, C, and Java interfaces"
  homepage "https://www-sop.inria.fr/indes/fp/Bigloo/"
  url "ftp://ftp-sop.inria.fr/indes/fp/Bigloo/bigloo4.2c.tar.gz"
  version "4.2c"
  sha256 "0fb246bf474326b36d50dd8c986901984544c932b2423279cc17e9d7c10bd10b"

  bottle do
    sha256 "3c5014716d4497a30d4891b2d45bf731570889af9529b7a69acb5d75228b31e8" => :sierra
    sha256 "4559f69e1f67193ac40d67540f1d05ca982a1866b0089d30c7c64ee5b263bd48" => :el_capitan
    sha256 "892d8ee4a85c7468114aec41155a582c32ca670eab27a51f767fcb4b41b45e24" => :yosemite
    sha256 "c885e9132385667245d8fa74032e01f7ba66e5f2cf626dc91822846087d1a3c6" => :mavericks
  end

  option "with-jvm", "Enable JVM support"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  depends_on "openssl"
  depends_on "gmp" => :recommended

  fails_with :clang do
    build 500
    cause <<-EOS.undent
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

    system "make"
    system "make", "install"

    # Install the other manpages too
    manpages = %w[bgldepend bglmake bglpp bgltags bglafile bgljfile bglmco bglprof]
    manpages.each { |m| man1.install "manuals/#{m}.man" => "#{m}.1" }
  end

  test do
    program = <<-EOS.undent
      (display "Hello World!")
      (newline)
      (exit)
    EOS
    assert_match "Hello World!\n", pipe_output("#{bin}/bigloo -i -", program)
  end
end
