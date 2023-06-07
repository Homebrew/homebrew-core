class Nghttp2 < Formula
  desc "HTTP/2 C Library"
  homepage "https://nghttp2.org/"
  url "https://github.com/nghttp2/nghttp2/releases/download/v1.53.0/nghttp2-1.53.0.tar.gz"
  mirror "http://fresh-center.net/linux/www/nghttp2-1.53.0.tar.gz"
  sha256 "f5f3f18b377d1e7658e4655a32d9a7ce6fef39fa13f600fe920f5f77c60fc34b"
  license "MIT"

  bottle do
    sha256 arm64_ventura:  "587adb383b8ae0c6ef1b006b703d1266ebc0d4928ac0055f100531f77b88a909"
    sha256 arm64_monterey: "9f0415e4e7c2a8cae6ed2c0d18ef4588f1ca731fde290e9bcfb86825c7061698"
    sha256 arm64_big_sur:  "d296890ad6965394f81cd53c04f089abccd0b26e2322102ec98850c7e9d0b4ec"
    sha256 ventura:        "246d595db48c4a388637329dfac565cf570a887e61dd4779da6a7eda8f1f3048"
    sha256 monterey:       "924cf7826f4005b43ba4ef1c29a82579affbf2fba804bb6f9dd4eb77e4a019c0"
    sha256 big_sur:        "81f479d4379c24c2b5d8f41297cb3b0345c761a65957817f919231d08483b806"
    sha256 x86_64_linux:   "4269c9334af6ca30a2640f0ec1441dd4a6c17c32a76e7e25c0990b7727dae451"
  end

  head do
    url "https://github.com/nghttp2/nghttp2.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "c-ares"
  depends_on "jemalloc"
  depends_on "libev"
  depends_on "libnghttp2"
  depends_on "openssl@1.1"

  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  # Fix: shrpx_api_downstream_connection.cc:57:3: error:
  # array must be initialized with a brace-enclosed initializer
  # https://github.com/nghttp2/nghttp2/pull/1269
  patch do
    on_linux do
      url "https://github.com/nghttp2/nghttp2/commit/829258e7038fe7eff849677f1ccaeca3e704eb67.patch?full_index=1"
      sha256 "c4bcf5cf73d5305fc479206676027533bb06d4ff2840eb672f6265ba3239031e"
    end
  end

  def install
    # fix for clang not following C++14 behaviour
    # https://github.com/macports/macports-ports/commit/54d83cca9fc0f2ed6d3f873282b6dd3198635891
    inreplace "src/shrpx_client_handler.cc", "return dconn;", "return std::move(dconn);"

    # Don't build nghttp2 library - use the previously built one.
    inreplace "Makefile.in", /(SUBDIRS =) lib/, "\\1"
    inreplace Dir["**/Makefile.in"] do |s|
      # These don't exist in all files, hence audit_result being false.
      s.gsub!(%r{^(LDADD = )\$[({]top_builddir[)}]/lib/libnghttp2\.la}, "\\1-lnghttp2", false)
      s.gsub!(%r{\$[({]top_builddir[)}]/lib/libnghttp2\.la}, "", false)
    end

    args = %W[
      --prefix=#{prefix}
      --disable-silent-rules
      --enable-app
      --disable-examples
      --disable-hpack-tools
      --disable-python-bindings
      --without-systemd
    ]

    system "autoreconf", "-ivf" if build.head?
    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    system bin/"nghttp", "-nv", "https://nghttp2.org"
    refute_path_exists lib
  end
end
