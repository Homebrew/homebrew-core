class Nghttp2 < Formula
  desc "HTTP/2 C Library"
  homepage "https://nghttp2.org/"
  url "https://github.com/nghttp2/nghttp2/releases/download/v1.47.0/nghttp2-1.47.0.tar.gz"
  sha256 "62f50f0e9fc479e48b34e1526df8dd2e94136de4c426b7680048181606832b7c"
  license "MIT"

  bottle do
    sha256 arm64_monterey: "abe5c740388c37a7157150056054a84658de7d822e8686463a8f47716232417c"
    sha256 arm64_big_sur:  "99d7e332e396d9b3058c18d8a94c854864ef64201ff9748dad0a4051356f3c17"
    sha256 monterey:       "b99ff44001abfa58b109928627cb4a2214a11a2415d2ca0c49a0601e4d346664"
    sha256 big_sur:        "4a5aa98db8472b7aaf97d0646f7a3550bf12ae28aaf45c9c1c1470b9a49c0528"
    sha256 catalina:       "132ba73b92472714c358b650ef668039b3219df92fd574e93753a23a6b93ccb9"
    sha256 x86_64_linux:   "a74b684df8a7ad4d908e65d63013a606832c0d20a1793bc6b25d97b8cdaff00d"
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

  on_linux do
    # Fix: shrpx_api_downstream_connection.cc:57:3: error:
    # array must be initialized with a brace-enclosed initializer
    # https://github.com/nghttp2/nghttp2/pull/1269
    patch do
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
