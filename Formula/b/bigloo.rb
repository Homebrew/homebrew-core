class Bigloo < Formula
  desc "Scheme implementation with object system, C, and Java interfaces"
  homepage "https://www-sop.inria.fr/indes/fp/Bigloo/"
  url "https://www-sop.inria.fr/indes/fp/Bigloo/download/bigloo-4.7b.tar.gz"
  sha256 "06271cc3da5c164d7fb4a5dc29c442f13d4f4b48319e63c40f8bfa12dc39f22c"
  license "GPL-2.0-or-later"
  head "https://github.com/manuel-serrano/bigloo.git", branch: "master"

  livecheck do
    url "https://www-sop.inria.fr/indes/fp/Bigloo/download/"
    regex(/href=.*?bigloo-(\d+(?:\.\d+)*[a-z]?(?:-\d+)?)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_golden_gate: "d4a98348d2651cdb124603b9032418875b906dfc443f206abbe38dd8c9a40f7e"
    sha256 arm64_tahoe:       "a75e58d36fd68cac86fc79db90752199ba7cb5726c033441b0242a0635d7e135"
    sha256 arm64_sequoia:     "b9d60b1a1aafabfc1ade5ff39f9a2a87b6fc1aff1809ad331d92a9938ec9dbf5"
    sha256 arm64_linux:       "c53fb3352cd374d23be5286bbc00f3b254f8233412fc8a51a60fc22edcaf369d"
    sha256 x86_64_linux:      "c808ccc3d85e2544761b7723959a76b0e1052d99ae1be40e31a10daf709ac040"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build

  depends_on "bdw-gc"
  depends_on "libunistring"
  depends_on "libuv"
  # configure runs `java -noverify`, which JDK 27 removed
  # https://github.com/manuel-serrano/bigloo/pull/157
  depends_on "openjdk@25"
  depends_on "openssl@4"
  depends_on "pcre2"
  depends_on "sqlite"

  uses_from_macos "zip" => :build

  on_linux do
    depends_on "alsa-lib"
    depends_on "gmp"
  end

  deny_network_access!

  def install
    # Force bigloo not to use vendored libraries
    inreplace "configure", /(^\s+custom\w+)=yes(;?)$/, "\\1=no\\2"
    rm_r(%w[
      gc
      gmp
      libbacktrace
      libunistring
      libuv
      pcre
      pcre2
    ])

    ENV.append_to_cflags "-I#{formula_opt_include("openssl@4")}"
    ENV.append "LDFLAGS", "-L#{formula_opt_lib("openssl@4")}"

    # These need to be passed after --prefix
    install_args = %W[
      --infodir=#{info}
      --mandir=#{man}
    ]

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
    # Record the keg-only JDK so the JVM backend does not depend on `PATH`
    args << "--javaprefix=#{formula_opt_bin("openjdk@25")}"

    if OS.mac?
      args << "--os-macosx"
      args << "--disable-alsa"
    else
      args << "--disable-libbacktrace"
    end

    # configure reads the Java version from the first line of `javac -version`, which `_JAVA_OPTIONS` pushes down
    with_env(_JAVA_OPTIONS: nil) { system "./configure", *args, *std_configure_args, *install_args }
    ENV.deparallelize
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
