class Bigloo < Formula
  desc "Scheme implementation with object system, C, and Java interfaces"
  homepage "https://www-sop.inria.fr/indes/fp/Bigloo/"
  url "ftp://ftp-sop.inria.fr/indes/fp/Bigloo/bigloo4.3c.tar.gz"
  version "4.3c"
  sha256 "1f9557fccf9c17a83fcef458384f2fd748b42777aefa8370cd657ed33b7ccef2"

  bottle do
    sha256 "5280c1fda3fee7c25845f8e14294884fb1b4963ff8e016baba77990d2465aafd" => :mojave
    sha256 "fac0529651e08dd5ceff5d4a45babb7f86b196753de53fa2487a12f502f5e91e" => :high_sierra
    sha256 "f3db359b927e3ac6175aac63ca06515738358d9509a137adf4cf8dbbc4ead0ce" => :sierra
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
