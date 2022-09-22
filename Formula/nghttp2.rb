class Nghttp2 < Formula
  desc "HTTP/2 C Library"
  homepage "https://nghttp2.org/"
  url "https://github.com/nghttp2/nghttp2/releases/download/v1.50.0/nghttp2-1.50.0.tar.gz"
  mirror "http://fresh-center.net/linux/www/nghttp2-1.50.0.tar.gz"
  sha256 "d162468980dba58e54e31aa2cbaf96fd2f0890e6dd141af100f6bd1b30aa73c6"
  license "MIT"

  bottle do
    sha256 arm64_monterey: "f6d8130a9f5625f68f6da8b1fd128b8560c410662177dd1eafd0e0887cb45377"
    sha256 arm64_big_sur:  "4d409aa9554e5e0cade07c4d2dec42b77ae992dc2b33af6aaa60788ea3200b32"
    sha256 monterey:       "f47eebd19f84268259673d7469835a4850e3168d1c9b3aaade7f4245c7c376d4"
    sha256 big_sur:        "c74c2c8f5f93b2ebf0ccb60a16501bbc91f387d1f2debd1faf440fb9416efafc"
    sha256 catalina:       "eedbc417e89dba315bc6e854b8d315967aaf7d509b5060d21f039c9c8d5a068f"
    sha256 x86_64_linux:   "576e2e477778c8c60a30c0a66d0decf3d79446af450693244f22ea1400534c8e"
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
