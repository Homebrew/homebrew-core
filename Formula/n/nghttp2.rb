class Nghttp2 < Formula
  desc "HTTP/2 C Library"
  homepage "https://nghttp2.org/"
  url "https://github.com/nghttp2/nghttp2/releases/download/v1.63.0/nghttp2-1.63.0.tar.gz"
  mirror "http://fresh-center.net/linux/www/nghttp2-1.63.0.tar.gz"
  sha256 "9318a2cc00238f5dd6546212109fb833f977661321a2087f03034e25444d3dbb"
  license "MIT"

  bottle do
    sha256 arm64_sequoia:  "5c7d02e5e38397cc7ac2eaece928ce96086049905abf0be03d44df61fe74f465"
    sha256 arm64_sonoma:   "1490d262d370565e6399f14557e025dd4d3ccf3e66429aa10752f53767b09396"
    sha256 arm64_ventura:  "e8ce0af1e523291e56047e1634bb6e708586dc690c015db53284a3acf11ed002"
    sha256 arm64_monterey: "e24a10fd5248deb0c987e7b275c0c1b6c9616b00edddf190849c205e95d7b443"
    sha256 sonoma:         "8bf2e26f765f1e145e8f7fba8a9cd869498b867ca7e4c5b5c852248fb6cc72b4"
    sha256 ventura:        "3640220afb57c9119758f684438af9f36eaeb7b1270f5387683b9415e5cf5202"
    sha256 monterey:       "2896740b3d373771797a09e29dd1c6a65e64e3f02482295dd395e5dd06460ee9"
    sha256 x86_64_linux:   "7a0b6480bad985d920b7d2394a05bfd8e56ad09df98b2a3e78bd2e847a3420fd"
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

  fails_with gcc: "11"

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
