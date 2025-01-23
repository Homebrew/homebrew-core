class Nghttp2 < Formula
  desc "HTTP/2 C Library"
  homepage "https://nghttp2.org/"
  url "https://github.com/nghttp2/nghttp2/releases/download/v1.64.0/nghttp2-1.64.0.tar.gz"
  mirror "http://fresh-center.net/linux/www/nghttp2-1.64.0.tar.gz"
  sha256 "20e73f3cf9db3f05988996ac8b3a99ed529f4565ca91a49eb0550498e10621e8"
  license "MIT"

  bottle do
    sha256 arm64_sequoia: "e626538d43446893a19c27979bf5bc759328bad620c7f4b2fec5749163095b54"
    sha256 arm64_sonoma:  "468740e1514254893cc0152051cc585c58e2198cf5a23f858acbdc77036e1843"
    sha256 arm64_ventura: "2a11bcd1f34969b3b0bc1c139620f6f6fd292dff88877ac6a8bcc4ff14e1957f"
    sha256 sonoma:        "f48ec7a32430def92612eaabad4c44a2107ea427457e6403eae124c0fb309114"
    sha256 ventura:       "21dd2b43f676e1d8258efc200739a496085040c9e12bce1bad585599f9c9a44b"
    sha256 x86_64_linux:  "b23ec98444cb5163f6f488604afe11c47c76b7e35c28f4aa1e63e0b521679f30"
  end

  head do
    url "https://github.com/nghttp2/nghttp2.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "c-ares"
  depends_on "jemalloc"
  depends_on "libev"
  depends_on "libnghttp2"
  depends_on "openssl@3"

  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  on_macos do
    # macOS 12 or older
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1400
  end

  on_linux do
    depends_on "gcc"
  end

  fails_with :clang do
    build 1400
    cause "Requires C++20 support"
  end

  fails_with :gcc do
    version "11"
    cause "Requires C++20 support"
  end

  def install
    ENV.llvm_clang if OS.mac? && DevelopmentTools.clang_build_version <= 1400

    # fix for clang not following C++14 behaviour
    # https://github.com/macports/macports-ports/commit/54d83cca9fc0f2ed6d3f873282b6dd3198635891
    inreplace "src/shrpx_client_handler.cc", "return dconn;", "return std::move(dconn);"

    # Don't build nghttp2 library - use the previously built one.
    inreplace "Makefile.in", /(SUBDIRS =) lib/, "\\1"
    inreplace Dir["**/Makefile.in"] do |s|
      # These don't exist in all files, hence audit_result being false.
      s.gsub!(%r{^(LDADD = )\$[({]top_builddir[)}]/lib/libnghttp2\.la}, "\\1-lnghttp2", audit_result: false)
      s.gsub!(%r{\$[({]top_builddir[)}]/lib/libnghttp2\.la}, "", audit_result: false)
    end

    args = %w[
      --disable-silent-rules
      --enable-app
      --disable-examples
      --disable-hpack-tools
      --disable-python-bindings
      --without-systemd
    ]

    system "autoreconf", "--force", "--install", "--verbose" if build.head?
    system "./configure", *args, *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    system bin/"nghttp", "-nv", "https://nghttp2.org"
    refute_path_exists lib
  end
end
