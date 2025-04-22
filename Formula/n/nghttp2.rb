class Nghttp2 < Formula
  desc "HTTP/2 C Library"
  homepage "https://nghttp2.org/"
  url "https://github.com/nghttp2/nghttp2/releases/download/v1.65.0/nghttp2-1.65.0.tar.gz"
  mirror "http://fresh-center.net/linux/www/nghttp2-1.65.0.tar.gz"
  sha256 "8ca4f2a77ba7aac20aca3e3517a2c96cfcf7c6b064ab7d4a0809e7e4e9eb9914"
  license "MIT"

  bottle do
    sha256 arm64_sequoia: "73507c5419805c1f355705a6da6d19675faa7df1db7b094e49147f73c4aca5a9"
    sha256 arm64_sonoma:  "7061b3fc947b387e23d8c83f037c1f795e9527bb23f68302d8002469a323738f"
    sha256 arm64_ventura: "21df76f5d99ef51a4e60dc146725c50da4f638aa7e531a164ebb632b7e8162b3"
    sha256 sonoma:        "87ad83548afab293d8f235b5d7821e77e8cd5a689db449e07ece94cfedaab169"
    sha256 ventura:       "257ead75ec0f1999cf0c901efd7fdb2ae22942377fe8a806ab93d95b77f059ff"
    sha256 arm64_linux:   "d79b088b2f12cf0e605864e710100b7901f2333324539b0e313063b0d33de59f"
    sha256 x86_64_linux:  "1a923f926f8dd37a197164c955270b4a37297711031e6c204d03535aef8ffa12"
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
    # macOS 12 or older
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1400
  end

  on_linux do
    depends_on "gcc"
  end

  fails_with :clang do
    build 1400
    cause "Requires C++20 support"
  end

  fails_with :gcc do
    version "11"
    cause "Requires C++20 support"
  end

  def install
    ENV.llvm_clang if OS.mac? && DevelopmentTools.clang_build_version <= 1400

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
