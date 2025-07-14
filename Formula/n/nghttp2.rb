class Nghttp2 < Formula
  desc "HTTP/2 C Library"
  homepage "https://nghttp2.org/"
  url "https://github.com/nghttp2/nghttp2/releases/download/v1.66.0/nghttp2-1.66.0.tar.gz"
  mirror "http://fresh-center.net/linux/www/nghttp2-1.66.0.tar.gz"
  sha256 "e178687730c207f3a659730096df192b52d3752786c068b8e5ee7aeb8edae05a"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "20ea8dcfeed5fde8c9792199c2af43ab04f5d1c88e7a3907f99b9e0b89d23cd0"
    sha256 cellar: :any,                 arm64_sonoma:  "77896cb1a06e09459c9f8658010cbc63391a83da609ea5d1c02dd253be8d2ba4"
    sha256 cellar: :any,                 arm64_ventura: "9bb9732aa5e6d6a7f29535c94f851995aeda41917d728e6e60690f0985261bda"
    sha256 cellar: :any,                 sonoma:        "4c717a81d420ff96dff267fa9ae9384cd4a6528643900843a6a7d8dc9f49c0fb"
    sha256 cellar: :any,                 ventura:       "f9d36daccc853e2d71d771e6d1d0fe8c71a0bf791a1626fa11723781bbd63ac8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "80bc5f0551dd694b145553635898067a618d7a1c1b27db74fff5af4d278588cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ae3de4374e9293eff1c07cb0fc7ef960cfb7444da930bf0ede9e39c8836a17f"
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
  depends_on "openssl@3"

  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1500
  end

  on_linux do
    depends_on "gcc"
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
    ENV.llvm_clang if OS.mac? && DevelopmentTools.clang_build_version <= 1500

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
