class Nghttp2 < Formula
  desc "HTTP/2 C Library"
  homepage "https://nghttp2.org/"
  url "https://github.com/nghttp2/nghttp2/releases/download/v1.50.0/nghttp2-1.50.0.tar.gz"
  mirror "http://fresh-center.net/linux/www/nghttp2-1.50.0.tar.gz"
  sha256 "d162468980dba58e54e31aa2cbaf96fd2f0890e6dd141af100f6bd1b30aa73c6"
  license "MIT"

  bottle do
    sha256 arm64_monterey: "6d3f13a35cad857895ea2a127e79a6ef5cf3331fd4dc630f16bce0b6afe689bb"
    sha256 arm64_big_sur:  "e0d2bcc458d51d2efe0a6e152d870dd8de98f1818bdaf5e698200d3e23cb9123"
    sha256 monterey:       "39abb63476c806f1475e0579f883b4e5b727ed8d19a21a87becd3a2e0514cbd1"
    sha256 big_sur:        "9c6e6ab0f887af49397c77240c4be2d9f8c2be2af119fe6fb9800958c7ec9ebf"
    sha256 catalina:       "03cec80f7a6e40907a55bd5fcda637353f91e12b8372384afc39aff63b635cf6"
    sha256 x86_64_linux:   "6f959539df4d94b7e5c9a0aa6debc65d30bf058797231a686a81f31867905106"
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
