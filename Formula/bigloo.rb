class Bigloo < Formula
  desc "Scheme implementation with object system, C, and Java interfaces"
  homepage "https://www-sop.inria.fr/indes/fp/Bigloo/"
  url "ftp://ftp-sop.inria.fr/indes/fp/Bigloo/bigloo-4.4b.tar.gz"
  sha256 "a313922702969b0a3b3d803099ea05aca698758be6bd0aae597caeb6895ce3cf"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www-sop.inria.fr/indes/fp/Bigloo/download.html"
    regex(/bigloo-latest\.t.+?\(([^)]+?)\)/i)
  end

  bottle do
    sha256 monterey: "2a90f9f41bcb3df423ba56186786156ff761733726f2d4ad4a2e09d1589429ea"
    sha256 big_sur:  "4ec0eade2fd256f4d25e4026200158b7ccc1a06b4c9554b503daaa9e7b0e8cab"
    sha256 catalina: "a64de44ab2d8674bde6500e0ac8646950f930d3296597ac6afee994ef3752096"
    sha256 mojave:   "73d13d970992f108d38bfac032f9ee0d37414e7bb6a8af093e199a69fc08bee5"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  depends_on "bdw-gc"
  depends_on "gmp"
  depends_on "libunistring"
  depends_on "libuv"
  depends_on "openjdk"
  depends_on "openssl@1.1"
  depends_on "pcre"

  # Fix a configure script bug. Remove when this lands in a release:
  # https://github.com/manuel-serrano/bigloo/pull/65
  patch do
    url "https://github.com/manuel-serrano/bigloo/commit/e74d7b3443171c974b032fb74d965c8ac4578237.patch?full_index=1"
    sha256 "9177d80b6bc647d08710a247a9e4016471cdec1ae35b390aceb04de44f5b4738"
  end

  def install
    # Force bigloo not to use vendored libraries
    inreplace "configure", /(^\s+custom\w+)=yes$/, "\\1=no"

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --mandir=#{man1}
      --infodir=#{info}
      --os-macosx
      --customgc=no
      --customlibuv=no
      --native=yes
      --disable-alsa
      --disable-mpg123
      --disable-flac
      --disable-srfi27
      --jvm=yes
    ]

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
