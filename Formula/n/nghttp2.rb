class Nghttp2 < Formula
  desc "HTTP/2 C Library"
  homepage "https://nghttp2.org/"
  url "https://github.com/nghttp2/nghttp2/releases/download/v1.67.1/nghttp2-1.67.1.tar.gz"
  mirror "http://fresh-center.net/linux/www/nghttp2-1.67.1.tar.gz"
  sha256 "da8d640f55036b1f5c9cd950083248ec956256959dc74584e12c43550d6ec0ef"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "d3bdb94dd4692d8aa41f54e67191f3cf2e2cf03e53bad026031967b9b78900a5"
    sha256 cellar: :any,                 arm64_sequoia: "35403d593507053fb6d2cf509e24f43897f7bf713f1b42f86e37867b54e9344c"
    sha256 cellar: :any,                 arm64_sonoma:  "fd512ded8ffa48afc21c8231032c0f14e83e58f1b989ae59a031d43e97101cc0"
    sha256 cellar: :any,                 sonoma:        "61bf7a85a2d978ad2e26477ec9ebed54d78b7125eca7d542a410b0411b70ed2e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "353049568227077d092013686eb23bee9cbf5fef5350284ff11d5a4084e91e69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c2de9fd14dd8545d06b1d0868427d78a1253ce90b02e2679103ec73ef2b074c2"
  end

  head do
    url "https://github.com/nghttp2/nghttp2.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "c-ares"
  depends_on "jemalloc"
  depends_on "libev"
  depends_on "libnghttp2"
  depends_on macos: :sonoma # Needs C++20 features not available on Ventura
  depends_on "openssl@3"

  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1500
  end

  fails_with :clang do
    build 1500
    cause "Requires C++20 support"
  end

  fails_with :gcc do
    version "11"
    cause "Requires C++20 support"
  end

  def install
    # fix for clang not following C++14 behaviour
    # https://github.com/macports/macports-ports/commit/54d83cca9fc0f2ed6d3f873282b6dd3198635891
    inreplace "src/shrpx_client_handler.cc", "return dconn;", "return std::move(dconn);"

    # Don't build nghttp2 library - use the previously built one.
    inreplace "Makefile.in", /(SUBDIRS =) lib/, "\\1"
    inreplace Dir["**/Makefile.in"] do |s|
      # These don't exist in all files, hence audit_result being false.
      s.gsub!(%r{^(LDADD = )\$[({]top_builddir[)}]/lib/libnghttp2\.la}, "\\1-lnghttp2", audit_result: false)
      s.gsub!(%r{\$[({]top_builddir[)}]/lib/libnghttp2\.la}, "", audit_result: false)
    end

    args = %w[
      --disable-silent-rules
      --enable-app
      --disable-examples
      --disable-hpack-tools
      --disable-python-bindings
      --without-systemd
    ]

    system "autoreconf", "--force", "--install", "--verbose" if build.head?
    system "./configure", *args, *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    system bin/"nghttp", "-nv", "https://nghttp2.org"
    refute_path_exists lib
  end
end
