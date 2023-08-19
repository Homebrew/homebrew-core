class Nghttp2 < Formula
  desc "HTTP/2 C Library"
  homepage "https://nghttp2.org/"
  url "https://github.com/nghttp2/nghttp2/releases/download/v1.55.1/nghttp2-1.55.1.tar.gz"
  mirror "http://fresh-center.net/linux/www/nghttp2-1.55.1.tar.gz"
  sha256 "e12fddb65ae3218b4edc083501519379928eba153e71a1673b185570f08beb96"
  license "MIT"

  bottle do
    sha256 arm64_ventura:  "dcc1fa311a01d212a202878717de5665a619dccadfafbd7cc47e27c8ce51e080"
    sha256 arm64_monterey: "5f2c41b857d16cf3376ba3fbca958a7d6c23c75455de609dbac993e8f39a326a"
    sha256 arm64_big_sur:  "9ebd00c59e3ed4f4298830c836ce078cca31b5c8257acea270f1d59efffd250c"
    sha256 ventura:        "edb91c6ce652d00d72c3d1616ab040ad76af26ef1c0ad258239debcdb60d1791"
    sha256 monterey:       "9730f312cd7f4d9ed35afc4a40ab8c8dcad2f52e3d100a2a1eaafe45e0eb41c6"
    sha256 big_sur:        "7df196c0dbb02b11bf57f0bbb2b33ab45817d691161e48372b887bdb7edd158d"
    sha256 x86_64_linux:   "496d9dc8509e607987944e22f2e36b510878e71fbafd3d2be1fddc6abadba232"
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
  depends_on "openssl@3"

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
