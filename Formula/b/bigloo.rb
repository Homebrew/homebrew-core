class Bigloo < Formula
  desc "Scheme implementation with object system, C, and Java interfaces"
  homepage "https://www-sop.inria.fr/indes/fp/Bigloo/"
  url "https://www-sop.inria.fr/indes/fp/Bigloo/download/bigloo-4.6a.tar.gz"
  sha256 "9705ec3de00cc1c51ee7699894841a3770c06a874215b45635b8844ae6daf0a6"
  license "GPL-2.0-or-later"
  head "https://github.com/manuel-serrano/bigloo.git", branch: "master"

  livecheck do
    url "https://www-sop.inria.fr/indes/fp/Bigloo/download.html"
    regex(/bigloo-latest\.t.+?\(([^)]+?)\)/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_sequoia: "9e898912750ff4524755d1523733824a82dfec9f4767f516a1cb0df291d02f6a"
    sha256 arm64_sonoma:  "fc56675d3c2d9dc400d02d0ba451fd0890e0af8530fddb01ae2f7a0b0e7732d5"
    sha256 arm64_ventura: "863ef84f5fe7ecde18164f1fd2b39a89d578aa6e5bee1d174441c455e9ff4dd1"
    sha256 sonoma:        "e8530b989fb53f9b92bc7de0e67291c8b74b10f615de0ba3afc6f2c2d806be77"
    sha256 ventura:       "0c5e0237240777f5e8471f3c0fbe471638fdf56d3308ddf021273b14ae88df6e"
    sha256 x86_64_linux:  "26df19d7509a28fdc224f29265138d5c4c7644e02256bda6c272614ef41ba09b"
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
