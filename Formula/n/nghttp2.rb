class Nghttp2 < Formula
  desc "HTTP/2 C Library"
  homepage "https://nghttp2.org/"
  url "https://github.com/nghttp2/nghttp2/releases/download/v1.67.1/nghttp2-1.67.1.tar.gz"
  mirror "http://fresh-center.net/linux/www/nghttp2-1.67.1.tar.gz"
  sha256 "da8d640f55036b1f5c9cd950083248ec956256959dc74584e12c43550d6ec0ef"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "fefb5c3c6a7548903f70d7ba02dca5c2176cd57c42b871fa8fbad70a7511b9d3"
    sha256 cellar: :any,                 arm64_sequoia: "a7e36a929b9a419297a3b61933546072148179e6c5b279c538c4b711cfe56f10"
    sha256 cellar: :any,                 arm64_sonoma:  "06af7af6393af54eb1adf66233c9074c7b04a298bf382ced857cb4e33db5c2ed"
    sha256 cellar: :any,                 sonoma:        "f7e33a5188e3aa3e043d3d5590253081018a78697e6b0be3435209bf2313b56a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8ec21faca8444e3037defd2b954fe82ffee387ffc3e28db0fda43e9ba2f39c35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6bfd1bb108307546b7958308c8f7c47cc9766dadd63c6db408bccf33cf7d4380"
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
