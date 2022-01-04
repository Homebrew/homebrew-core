class Bigloo < Formula
  desc "Scheme implementation with object system, C, and Java interfaces"
  homepage "https://www-sop.inria.fr/indes/fp/Bigloo/"
  url "ftp://ftp-sop.inria.fr/indes/fp/Bigloo/bigloo-4.4c-3.tar.gz"
  version "4.4c-3"
  sha256 "43bcd0b0a67287f70f1590f4d7b6d61528129e7dac0d858b5a19836b17bb2b68"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www-sop.inria.fr/indes/fp/Bigloo/download.html"
    regex(/bigloo-latest\.t.+?\(([^)]+?)\)/i)
  end

  bottle do
    sha256 monterey:     "ed335d97b009a6203d2bca3c87df2f4ed98c4f79e0a3545b41b98b7844104ded"
    sha256 big_sur:      "e9db76f06fb4772881892f28ec4fb5a94250182bf6634e2f4580fd8ec4a9f3bf"
    sha256 catalina:     "1fdadbe6cf4b68c7dc09c47e5af14e3917af3c265338bd387ce4770fb8f63bc7"
    sha256 x86_64_linux: "4ec5c1d9728e08e76b25363109a7fc23c89791f70f32d256daad990d35c65f18"
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
