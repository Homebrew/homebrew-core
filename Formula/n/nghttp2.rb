class Nghttp2 < Formula
  desc "HTTP/2 C Library"
  homepage "https://nghttp2.org/"
  url "https://github.com/nghttp2/nghttp2/releases/download/v1.68.0/nghttp2-1.68.0.tar.gz"
  mirror "http://fresh-center.net/linux/www/nghttp2-1.68.0.tar.gz"
  sha256 "2c16ffc588ad3f9e2613c3fad72db48ecb5ce15bc362fcc85b342e48daf51013"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b7be3d515c9362428c703d65e45e0cc12394b2a2eca61f5feb398421ce1f2b72"
    sha256 cellar: :any,                 arm64_sequoia: "c2c240b8ff5ed52921555bad20cfc5649332b254bfe98d62369f81bf7c6b64fe"
    sha256 cellar: :any,                 arm64_sonoma:  "96d45f2d2de69efd37ccd92f4195f8dd1e5812704f47f27775b6d6e659528c8a"
    sha256 cellar: :any,                 sonoma:        "a2127d1b956e99f06e395c1c11344a3d59e3bbfd31a3633d12d982b1a98c2a07"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a21f417bcbeb033c594478b3de4c559997420a378b334a3278766897a3da7983"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2fc15f87a76fe5088393c12dbfc1323696bbb5e43c5a86e2c66492777adc00fd"
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
