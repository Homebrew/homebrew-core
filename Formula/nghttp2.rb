class Nghttp2 < Formula
  desc "HTTP/2 C Library"
  homepage "https://nghttp2.org/"
  url "https://github.com/nghttp2/nghttp2/releases/download/v1.47.0/nghttp2-1.47.0.tar.gz"
  sha256 "62f50f0e9fc479e48b34e1526df8dd2e94136de4c426b7680048181606832b7c"
  license "MIT"

  bottle do
    sha256 arm64_monterey: "dd713ae5e09d42b3565b0948fd710e340231f97c9125d3aaa3aac69b11648140"
    sha256 arm64_big_sur:  "d460789e9fd34f91aa1e9e4ca1b7f19a1d404bfe5a2436137da377316efbea93"
    sha256 monterey:       "a4c091e6343a0153b4ea4223d8a5f22f598a2cd874ae0080b605e812bce9f131"
    sha256 big_sur:        "da456fbcfd7be04c28fe0882f7ba187db2c584ccc3eabc5ab631ac8278513984"
    sha256 catalina:       "e667dd7d98de20e202058c50faf84645e1379bb60b55a49a8cd7eee6b4adfcc9"
    sha256 mojave:         "961ca4a0fb74c72bd1e184351aa375c60df79410acd0a1f8930e23584c9e6b86"
    sha256 x86_64_linux:   "690725dd14f28ac675bc901d789a5d17474c00a4914012a4b67e63027af6004f"
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
