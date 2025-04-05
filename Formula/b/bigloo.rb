class Bigloo < Formula
  desc "Scheme implementation with object system, C, and Java interfaces"
  homepage "https://www-sop.inria.fr/indes/fp/Bigloo/"
  url "https://www-sop.inria.fr/indes/fp/Bigloo/download/bigloo-4.6a.tar.gz"
  sha256 "d17202735162db2e6aecee98f180a32567a6fb11ffde80924e76f4534a6a7977"
  license "GPL-2.0-or-later"
  head "https://github.com/manuel-serrano/bigloo.git", branch: "master"

  livecheck do
    url "https://www-sop.inria.fr/indes/fp/Bigloo/download.html"
    regex(/bigloo-latest\.t.+?\(([^)]+?)\)/i)
  end

  bottle do
    sha256 arm64_sequoia: "6bfb6e05b7b761e60e5a0eee80d23db93e60adbb0880f5e958e5e49f0abaeaad"
    sha256 arm64_sonoma:  "8723768bd382b813e4f174748f7e24a30c4057fc621b85bfe626f2de3733d22c"
    sha256 arm64_ventura: "8c89e1697c5edc4553159ed58c38cb335e13ce7f77c42344c775366cbcf86b5f"
    sha256 sonoma:        "124693cf3bfbab077a4f5a04ec303afee067cdae075c0b592d94a086cec29ff0"
    sha256 ventura:       "96afc3354138710c08ee5a425a14873ecc26b89e9fd17f878395a3bd30224d87"
    sha256 x86_64_linux:  "c9f677f9a73a1f415d34af3d0a77b04f4b7279caa0b6e9447fcce5fdf5b7d874"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build

  depends_on "bdw-gc"
  depends_on "gmp"
  depends_on "libunistring"
  depends_on "libuv"
  depends_on "openjdk"
  depends_on "openssl@3"
  depends_on "pcre2"
  depends_on "sqlite"

  on_linux do
    depends_on "alsa-lib"
  end

  def install
    # Force bigloo not to use vendored libraries
    inreplace "configure", /(^\s+custom\w+)=yes$/, "\\1=no"

    # configure doesn't respect --mandir or MANDIR
    inreplace "configure", "$prefix/man/man1", "$prefix/share/man/man1"

    # configure doesn't respect --infodir or INFODIR
    inreplace "configure", "$prefix/info", "$prefix/share/info"

    args = %w[
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
      args << "--os-macosx"
      args << "--disable-alsa"
    else
      args << "--disable-libbacktrace"
    end

    system "./configure", *args, *std_configure_args
    system "make"
    system "make", "install"

    # Install the other manpages too
    manpages = %w[bgldepend bglmake bglpp bgltags bglafile bgljfile bglmco bglprof]
    manpages.each { |m| man1.install "manuals/#{m}.man" => "#{m}.1" }
  end

  test do
    program = <<~SCHEME
      (display "Hello World!")
      (newline)
      (exit)
    SCHEME
    assert_match "Hello World!\n", pipe_output("#{bin}/bigloo -i -", program, 0)
  end
end
