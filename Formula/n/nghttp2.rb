class Nghttp2 < Formula
  desc "HTTP/2 C Library"
  homepage "https://nghttp2.org/"
  url "https://github.com/nghttp2/nghttp2/releases/download/v1.57.0/nghttp2-1.57.0.tar.gz"
  mirror "http://fresh-center.net/linux/www/nghttp2-1.57.0.tar.gz"
  sha256 "1e3258453784d3b7e6cc48d0be087b168f8360b5d588c66bfeda05d07ad39ffd"
  license "MIT"

  bottle do
    sha256 arm64_sonoma:   "7722c2224fd438b5b0833916657da3b3dfab9a501e5f766fab3cb0a634ec88bd"
    sha256 arm64_ventura:  "e725ed12af2a06244546f2c807a23413fdd59c157c45bcbcce15c8aef08d3173"
    sha256 arm64_monterey: "b58f4b4d65b84175c1896e20e1ecc01cab28cdd6373ee9900b9e8a1ef58d7170"
    sha256 sonoma:         "af49d830fac0a732bc27070c8f6731f8d3bcd9e72534d9c2c605000deec5e9a7"
    sha256 ventura:        "14e3c8391844843c34fff20bdb8774d1663ffa9d3d07e224310bfc50fac24c2e"
    sha256 monterey:       "ddd2556c7aee932e5769db3c10ca1b1b11389999f34b3f8be6239473d7e8c534"
    sha256 x86_64_linux:   "b61d291bb84958a5426c744a61ca7e20b5a043b377f9b984d2767b6529159af0"
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
