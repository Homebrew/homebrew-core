class Bigloo < Formula
  desc "Scheme implementation with object system, C, and Java interfaces"
  homepage "https://www-sop.inria.fr/indes/fp/Bigloo/"
  url "ftp://ftp-sop.inria.fr/indes/fp/Bigloo/bigloo4.3a.tar.gz"
  version "4.3a"
  sha256 "3ca5c28d6eab6132b981eb6a8cc921d73b5cbcc22d3a32312d52f83d8dc62c0f"

  bottle do
    sha256 "d8cc153227a4cf654d69e617754351d01b1e8a7648e0566f1f09d590e29a6077" => :high_sierra
    sha256 "b6e3d1c848387656e4ac1fd29e3253a33027d0016fb59f698c9c0ceee7d6eeca" => :sierra
    sha256 "c1d07d96de7ec2377b02b9103d5d64cbaa80f2a19605e6da9cc99115e0757976" => :el_capitan
    sha256 "4df885d857ae5a8bec050edb9e010b61cdcdcfefee21f48209df9f8b7a1dd60c" => :yosemite
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
