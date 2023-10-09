class Bigloo < Formula
  desc "Scheme implementation with object system, C, and Java interfaces"
  homepage "https://www-sop.inria.fr/indes/fp/Bigloo/"
  url "ftp://ftp-sop.inria.fr/indes/fp/Bigloo/bigloo-4.5a-1.tar.gz"
  version "4.5a-1"
  sha256 "d8f04e889936187dc519719b749ad03fe574165a0b6d318e561f1b3bce0d5808"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url "https://www-sop.inria.fr/indes/fp/Bigloo/download.html"
    regex(/bigloo-latest\.t.+?\(([^)]+?)\)/i)
  end

  bottle do
    sha256 sonoma:       "e81480115cd0279b70e7d43f3f978fb9d2f8f3cc043a890af5143747152874a8"
    sha256 ventura:      "5465147a4efa0ac5b2310a832f37e26ba99cd1b3e84be0ee9e191f006954221c"
    sha256 monterey:     "d37972292b5b057f01e31f128ed92e10d78ebfd5860efb0d30e21a245d58760c"
    sha256 big_sur:      "6f82be6c432a3e6d61a93d0438255d4ef42e4a2359d16547fd2cbd6cf6bf161e"
    sha256 x86_64_linux: "b7a836944014403c1ca5e2d665cde655447345fdd307c9dd68e6220278a52197"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  depends_on arch: :x86_64
  depends_on "bdw-gc"
  depends_on "gmp"
  depends_on "libunistring"
  depends_on "libuv"
  depends_on "openjdk"
  depends_on "openssl@3"
  depends_on "pcre2"

  on_linux do
    depends_on "alsa-lib"
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
      --customgc=no
      --customgmp=no
      --customlibuv=no
      --customunistring=no
      --native=yes
      --disable-mpg123
      --disable-flac
      --jvm=yes
    ]

    if OS.mac?
      args += %w[
        --os-macosx
        --disable-alsa
      ]
    end

    if OS.linux?
      args += %w[
        --disable-libbacktrace
      ]
    end

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
