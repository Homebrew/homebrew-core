class Bigloo < Formula
  desc "Scheme implementation with object system, C, and Java interfaces"
  homepage "https://www-sop.inria.fr/indes/fp/Bigloo/"
  url "ftp://ftp-sop.inria.fr/indes/fp/Bigloo/bigloo-4.4c-4.tar.gz"
  version "4.4c-4"
  sha256 "4ed71a86c6d762c35352e9f04871a11fe90fa5dbc974e728a86d9e8229d7c70f"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www-sop.inria.fr/indes/fp/Bigloo/download.html"
    regex(/bigloo-latest\.t.+?\(([^)]+?)\)/i)
  end

  bottle do
    sha256 monterey:     "006090398ac8d5fce740515e90fc2595f7f4dfc47fe9a552cbc7daa72564d612"
    sha256 big_sur:      "2de450455ea939cd85b806b65811ddb53f7265ddd705f597caa0c08704091530"
    sha256 catalina:     "7afa0f7e7688f345db9532c1de33ea1480b1a497becfcaf1c28a78c9f6ef6253"
    sha256 x86_64_linux: "4f8bc7f55a1eb64c94d3373fdd49d1186886489dbba357dd10890acaa1ac3c1c"
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
  depends_on "pcre2"

  on_linux do
    depends_on "alsa-lib"
  end

  # Fix gmp detection.
  # https://github.com/manuel-serrano/bigloo/pull/69
  patch do
    url "https://github.com/manuel-serrano/bigloo/commit/d3f9c4e6a6b3eb9a922eb92a2e26b15bc5c879dc.patch?full_index=1"
    sha256 "3b3522b30426770c82b620d3307db560852c2aadda5d80b62b18296d325cc38c"
  end

  # Fix pcre2 detection.
  # https://github.com/manuel-serrano/bigloo/pull/70
  patch do
    url "https://github.com/manuel-serrano/bigloo/commit/4a5ec57b92fef4e23eb7d56dca402fb2b1f6eeb2.patch?full_index=1"
    sha256 "d81b3dbc22e6a78b7517ff761d8c1ab5edef828b1a782cb9c4a672923844b948"
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
