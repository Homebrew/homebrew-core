class Nghttp2 < Formula
  desc "HTTP/2 C Library"
  homepage "https://nghttp2.org/"
  url "https://github.com/nghttp2/nghttp2/releases/download/v1.60.0/nghttp2-1.60.0.tar.gz"
  mirror "http://fresh-center.net/linux/www/nghttp2-1.60.0.tar.gz"
  sha256 "ca2333c13d1af451af68de3bd13462de7e9a0868f0273dea3da5bc53ad70b379"
  license "MIT"

  bottle do
    sha256 arm64_sonoma:   "e50cfce227bf09f675e40a370a5c414e2735cca7244c7fe17a11eb438e5c1b84"
    sha256 arm64_ventura:  "841530a98a4d518532941a95953d2e3bf3d58dfb3c807a8fdcf21b9f0f28fbc4"
    sha256 arm64_monterey: "858a06babe5c326da7ddd5b5a1c8c282f001e05130374f5fe1b566317fbf1978"
    sha256 sonoma:         "34cdcce816c48e125d5037cf709324b9e70d2cd94402b812489d263005c9bbb0"
    sha256 ventura:        "775d21567ae1ee514db793eb61342ace2a94a755b5a3f9632be596870edb4191"
    sha256 monterey:       "044207b0b10e14b20e95c561dc199ed289479fa17bd1a10790526fd574355f74"
    sha256 x86_64_linux:   "d98fa7255c53ad261a5cb6f3e64fbe58d17a38e7f1d40ef6c382f3f4e2b3d785"
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
