class Nghttp2 < Formula
  desc "HTTP/2 C Library"
  homepage "https://nghttp2.org/"
  url "https://github.com/nghttp2/nghttp2/releases/download/v1.59.0/nghttp2-1.59.0.tar.gz"
  mirror "http://fresh-center.net/linux/www/nghttp2-1.59.0.tar.gz"
  sha256 "90fd27685120404544e96a60ed40398a3457102840c38e7215dc6dec8684470f"
  license "MIT"

  bottle do
    sha256 arm64_sonoma:   "fd1c1c0f1e6ae7d4acc92021227b23ad0044d57f26a62d031ac0f8808672e981"
    sha256 arm64_ventura:  "80a4bcdde626b2d10f034d190fbf4542e4e6a0f9c9aeca6bf7b9dce1979b861b"
    sha256 arm64_monterey: "d8190d95c6b525021f9c28011b20ade29917f0085619c2631a49b19914e663aa"
    sha256 sonoma:         "6dfa74eef20ffdc5db9283f2ff1935bbd7db3dc022f869b9accee48f1e6326ac"
    sha256 ventura:        "2ce2186c10b6fc1ac33a803b9158dc417f7885d78b2d9cc5ff4a2f4725b879a9"
    sha256 monterey:       "4cc04dd5d0d3b6e89c0617d05a71b92491a8d943b0aa874d6a3b33fc0141f2c0"
    sha256 x86_64_linux:   "6d6e0ff3d7d24ecc703cae91012d55a50bd8e12caba0fdee0abaf3258a6b21f3"
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
