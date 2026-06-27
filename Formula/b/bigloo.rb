class Bigloo < Formula
  desc "Scheme implementation with object system, C, and Java interfaces"
  homepage "https://www-sop.inria.fr/indes/fp/Bigloo/"
  url "https://www-sop.inria.fr/indes/fp/Bigloo/download/bigloo-4.7a.tar.gz"
  sha256 "4425c37f499e2df1a7be3334ae8520fd76214733d9d9fe97b2fba71d1c4cf63b"
  license "GPL-2.0-or-later"
  head "https://github.com/manuel-serrano/bigloo.git", branch: "master"

  livecheck do
    url "https://www-sop.inria.fr/indes/fp/Bigloo/download/"
    regex(/href=.*?bigloo-(\d+(?:\.\d+)*[a-z]?(?:-\d+)?)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "11f7b488d0a97682bdd9a21520fb44c86b68c35d9b07654732a9805cab999ae0"
    sha256 arm64_sequoia: "590f9170ba36f83430d2ed9fdb2f043ef66ae237baa567842721a72de09bd997"
    sha256 arm64_sonoma:  "bb9b651b527caa4736a17ae09e98b56b48a1654b741d59ed3075826389e86963"
    sha256 sonoma:        "80c07844cddc69479f05e9344afaf486f82c0dc67e0149e9300c66a79f3d14c4"
    sha256 arm64_linux:   "45843491137d0e4d47f649464784636973f2f784f01577fd5134130a332d6db6"
    sha256 x86_64_linux:  "5431a4fb5ad2aba6aa3fb7d8d695df6a5544e5f4b5acef5a00b602abda9fe026"
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
