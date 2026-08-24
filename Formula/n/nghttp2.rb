class Nghttp2 < Formula
  desc "HTTP/2 C Library"
  homepage "https://nghttp2.org/"
  url "https://github.com/nghttp2/nghttp2/releases/download/v1.70.0/nghttp2-1.70.0.tar.gz"
  sha256 "aa317e2cf9dca6afa0aed68f8fad6ff303ec6982e25a78c75c0b65e2b9b3ded5"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "2f36cb8a86910371dfcd4963b1d50ae82522c077d37041ed56198181262a3b03"
    sha256 cellar: :any, arm64_sequoia: "32b441750d304f3621feaf0424880dfb6aa0bb6563fcc85e59bc361a895f45a2"
    sha256 cellar: :any, arm64_sonoma:  "926f2b7a4c85a24ce41d46bfaf3fe97daa0047233377f44fcd8322967340c72e"
    sha256 cellar: :any, sonoma:        "3dbdd0376f89bd63e9b473993ad9d5db5dacb46f38b8431d435b1642f33433c0"
    sha256 cellar: :any, arm64_linux:   "5606a9f74f3670f803f91cab65703119cd264b088f319e79483ecf7ebe4c731a"
    sha256 cellar: :any, x86_64_linux:  "bb8ceeb4c929cf58760de0004852e160811df4ae409993cd0373409bd851817a"
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

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1500
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  fails_with :clang do
    build 1500
    cause "Requires C++23 <print> header"
  end

  fails_with :gcc do
    version "13"
    cause "Requires C++23 <print> header"
  end

  def install
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
