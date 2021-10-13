class Nghttp2 < Formula
  desc "HTTP/2 C Library"
  homepage "https://nghttp2.org/"
  # Keep in sync with libnghttp2.
  url "https://github.com/nghttp2/nghttp2/releases/download/v1.45.1/nghttp2-1.45.1.tar.gz"
  sha256 "2379ebeff7b02e14b9a414551d73540ddce5442bbecda2748417e8505916f3e7"
  license "MIT"
  revision 1

  bottle do
    sha256 arm64_big_sur: "c52a2fc0e1f3f16bf6df5c1007622aefc4fa9dc6fa215445dd136dcfdea887b3"
    sha256 big_sur:       "4c27ecc896ba42f7d13ed5a517379acf5324f10e8a7002fb42d6baf2561c3b09"
    sha256 catalina:      "8a5006adf2211cb0ada8cb080e649a3b282f4d7a2a13a9327d874031ba255688"
    sha256 mojave:        "d2533b8770ad97091c585ec6c7387ac855b86ecdad449274664411d18a336cf6"
    sha256 x86_64_linux:  "0e46f88673aff544e8a5dcbc38a75f5280fa891c620d39e6196723540d41b64a"
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
