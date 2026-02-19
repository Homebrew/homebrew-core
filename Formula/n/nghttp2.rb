class Nghttp2 < Formula
  desc "HTTP/2 C Library"
  homepage "https://nghttp2.org/"
  url "https://github.com/nghttp2/nghttp2/releases/download/v1.68.0/nghttp2-1.68.0.tar.gz"
  mirror "http://fresh-center.net/linux/www/nghttp2-1.68.0.tar.gz"
  sha256 "2c16ffc588ad3f9e2613c3fad72db48ecb5ce15bc362fcc85b342e48daf51013"
  license "MIT"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "a2d1e55d45369690662a1c729ee2e0261b373f3afc4954666d8c5b6a9898acbc"
    sha256 cellar: :any,                 arm64_sequoia: "5f1406f8602d219785670c46b8b8426f0bd0d3056e196132ef7cdcdd839c1170"
    sha256 cellar: :any,                 arm64_sonoma:  "1680f9e557ce6ab597e6ba797c64af7b3d810471334ac83f570bee189c488b20"
    sha256 cellar: :any,                 sonoma:        "58b8610ecbbf4e5c7e376334b86228a3d80551f275972730a76153cdd3928ff7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "66278dfee59169e7e2054e4490884d2593f3e22b5ab02479c7d4edd05762648e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b398fcfab78f81b200b70dc2b0320694a99e73c50777379f309fa287b4c7bd15"
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
  depends_on macos: :sonoma # Needs C++20 features not available on Ventura
  depends_on "openssl@3"

  uses_from_macos "libxml2"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1500
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  fails_with :clang do
    build 1500
    cause "Requires C++20 support"
  end

  fails_with :gcc do
    version "11"
    cause "Requires C++20 support"
  end

  def install
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
