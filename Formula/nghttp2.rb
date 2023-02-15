class Nghttp2 < Formula
  desc "HTTP/2 C Library"
  homepage "https://nghttp2.org/"
  url "https://github.com/nghttp2/nghttp2/releases/download/v1.52.0/nghttp2-1.52.0.tar.gz"
  mirror "http://fresh-center.net/linux/www/nghttp2-1.52.0.tar.gz"
  sha256 "9877caa62bd72dde1331da38ce039dadb049817a01c3bdee809da15b754771b8"
  license "MIT"

  bottle do
    sha256 arm64_ventura:  "826b4e8636144e38625be9047827091b21ebd87c4f9c1608ee97d457a1da7be4"
    sha256 arm64_monterey: "224b62a8c7c9a6c2f28046f0dd2e49c2109d70f2e38f86a6afea088040149f21"
    sha256 arm64_big_sur:  "5f1342646003a7a0c697a2f6a734c04b85891d94649ba39ec1d74e07f7bf61b3"
    sha256 ventura:        "c188287b3708ae3656f0395ac486d23f55cd17e524c3a2dde666017415419ce0"
    sha256 monterey:       "0b7f60bc072bc4d2ec0c76c72c6397fbe2e5eeafcb6d18917f55f097887dec98"
    sha256 big_sur:        "7c0673d4575ce0f2df65c82d22b361cea475c92edcaf793dd10373fa160ac3e2"
    sha256 x86_64_linux:   "dbec8d0ae69d5a4cb4aab0c43633aad827e8b156af2727b680caced10e4c6122"
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
