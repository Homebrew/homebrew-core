class Nghttp2 < Formula
  desc "HTTP/2 C Library"
  homepage "https://nghttp2.org/"
  url "https://github.com/nghttp2/nghttp2/releases/download/v1.54.0/nghttp2-1.54.0.tar.gz"
  mirror "http://fresh-center.net/linux/www/nghttp2-1.54.0.tar.gz"
  sha256 "890cb0761d2fac570f0aa7bce085cd7d3c77bcfd56510456b6ea0278cde812f0"
  license "MIT"
  revision 1

  bottle do
    sha256 arm64_ventura:  "890634f1d69a36e62202197a07eddf858e9f391403a6ba993a245f73b321f714"
    sha256 arm64_monterey: "da60a4c84f1701c825d1db9b3760ed2b1c31511d54fdce8976f7cf86912a3c9c"
    sha256 arm64_big_sur:  "13d12d740d2a824f627ea3a76293d038394793ce19661f7ad41a5d9ab98b4e7e"
    sha256 ventura:        "dfffb690be35c18a17d33ae3a22fdf6cdecf07210384a1bd6cd6ae6fb604f3aa"
    sha256 monterey:       "e27b6ed67cc86a82908c2ffe52ec7061f956932f0a181325440d62f7df352ebb"
    sha256 big_sur:        "342b1aa84a0c7446c4c64d844d3df8f97937fac780a5181baab149c7f97f57bb"
    sha256 x86_64_linux:   "50a8b54e04e58404b71f5672f447375011c26b00796ab533ab590ba45e99bb9b"
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
