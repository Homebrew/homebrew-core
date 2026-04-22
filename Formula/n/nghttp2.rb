class Nghttp2 < Formula
  desc "HTTP/2 C Library"
  homepage "https://nghttp2.org/"
  url "https://github.com/nghttp2/nghttp2/releases/download/v1.69.0/nghttp2-1.69.0.tar.gz"
  mirror "http://fresh-center.net/linux/www/nghttp2-1.69.0.tar.gz"
  sha256 "c866b7477cbb7512ab6863a685027adbb1bb8da8fc3bab7429ed43d3281d5aa9"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b2e05c11cc4a132f3b38c5cc1a724f3c7db34fb28f99f0ed5220c849d815119e"
    sha256 cellar: :any,                 arm64_sequoia: "4cb7547b401741b6f3d908f3e8cd15546ad6f79bd08c30682eba5a7a775e8a53"
    sha256 cellar: :any,                 arm64_sonoma:  "69224a4a6f324e65af2d5ff259af6ec30702ad1e1abd61c1f9489d6d6f91c26b"
    sha256 cellar: :any,                 sonoma:        "7a700d492e5f10c3af5fdc8231000247095b9c24a889de40f772744b6835123c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ebf951646a2bf3ae5357eb28b1eff1814557ca1eb05f33533846d4032127af8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "888926049373d180eedbad78d96728728d3a9901b8750de8bec18240c4c5e4f6"
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
