class Bigloo < Formula
  desc "Scheme implementation with object system, C, and Java interfaces"
  homepage "https://www-sop.inria.fr/indes/fp/Bigloo/"
  url "ftp://ftp-sop.inria.fr/indes/fp/Bigloo/bigloo-4.5b.tar.gz"
  sha256 "864d525ee6a7ff339fd9a8c973cc46bf9a623a3827d84bfb6e04a29223707da5"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www-sop.inria.fr/indes/fp/Bigloo/download.html"
    regex(/bigloo-latest\.t.+?\(([^)]+?)\)/i)
  end

  bottle do
    rebuild 1
    sha256 sonoma:       "7c420cdf1da7454605ebda44ec9ab6c90dad2d9e3a8f6cb43bfb6341479f4971"
    sha256 ventura:      "c9c8be5bd55652c23c05de35d1c7f704a851003a0a2759741a1fbe50c75bc458"
    sha256 x86_64_linux: "57660e09f1eea22c2e2faae872353d1c1229e76a19d4dddbee07978bbe94e312"
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
  depends_on "sqlite"

  on_linux do
    depends_on "alsa-lib"
  end

  def install
    # Remove when included in a release:
    # https://github.com/manuel-serrano/bigloo/commit/8b2a912c7c668a2a0bfa2ec30bc68bfdd05d2d7f
    ENV.append_to_cflags "-Wno-incompatible-function-pointer-types" if DevelopmentTools.clang_build_version >= 1500

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
    program = <<~EOS
      (display "Hello World!")
      (newline)
      (exit)
    EOS
    assert_match "Hello World!\n", pipe_output("#{bin}/bigloo -i -", program)
  end
end
