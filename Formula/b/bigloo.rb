class Bigloo < Formula
  desc "Scheme implementation with object system, C, and Java interfaces"
  homepage "https://www-sop.inria.fr/indes/fp/Bigloo/"
  url "https://www-sop.inria.fr/indes/fp/Bigloo/download/bigloo-4.6a.tar.gz"
  sha256 "6772f6a17b7f002171d433f1270344a6bbbefb17e2718b0456656aa8c0b0d9c1"
  license "GPL-2.0-or-later"
  head "https://github.com/manuel-serrano/bigloo.git", branch: "master"

  livecheck do
    url "https://www-sop.inria.fr/indes/fp/Bigloo/download.html"
    regex(/bigloo-latest\.t.+?\(([^)]+?)\)/i)
  end

  bottle do
    rebuild 2
    sha256 arm64_tahoe:   "58fd054dced50f890349a99de351aba43c55166c09535636547b5ba901266281"
    sha256 arm64_sequoia: "94b9559cbc116e2f6c197b2b656f257dd67a8b5a989c1795cd2bbe81056bfcb7"
    sha256 arm64_sonoma:  "f0c10fd7976cb0eac42f37408ac7672199a5ef17306720b33bba8f4c5ab0ec6f"
    sha256 sonoma:        "1ce2fd31a7a7d39ca08dd51e888ab21d6aa0b82e747e97eaa9349cca4970888a"
    sha256 arm64_linux:   "dec793d2615180d1e9174f4c89083d8ab77195c6cbb5589a2ee2952dde557687"
    sha256 x86_64_linux:  "a56a68b65951a1ce99b2f4615929f6ef4c8f9b5dbb80348cbcfc94ba17da5e4c"
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
