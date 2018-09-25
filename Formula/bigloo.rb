class Bigloo < Formula
  desc "Scheme implementation with object system, C, and Java interfaces"
  homepage "https://www-sop.inria.fr/indes/fp/Bigloo/"
  url "ftp://ftp-sop.inria.fr/indes/fp/Bigloo/bigloo4.3c.tar.gz"
  version "4.3c"
  sha256 "ae1c93c0a9ac5d412223abfa7994fff6595549a71e984c9fedc3120adc6ca92e"

  bottle do
    sha256 "1b6fce918e35cc37fb6e2c9d10f36b48866cdeaa577026114ff533efc72fb361" => :high_sierra
    sha256 "5aef2cf4b59096ddc38cf12698543f18a68b784aa0b12beefb646334c3a89ef4" => :sierra
    sha256 "41947394e3272672e20f2980e4bfbad317fcdaced331d9478322550cc8cd9024" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "gmp"
  depends_on "libunistring"
  depends_on "openssl"

  fails_with :clang do
    build 500
    cause <<~EOS
      objs/obj_u/Ieee/dtoa.c:262:79504: fatal error: parser
      recursion limit reached, program too complex
    EOS
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man1}",
                          "--infodir=#{info}",
                          "--customgc=yes",
                          "--os-macosx",
                          "--native=yes",
                          "--disable-alsa",
                          "--disable-flac",
                          "--disable-mpg123"
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
