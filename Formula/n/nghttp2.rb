class Nghttp2 < Formula
  desc "HTTP/2 C Library"
  homepage "https://nghttp2.org/"
  url "https://github.com/nghttp2/nghttp2/releases/download/v1.71.0/nghttp2-1.71.0.tar.gz"
  sha256 "0cdd35ecec77919b4b7b245f87fe8d2216e3d62da854eb0838c594ff058042fc"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "c8b46996ac9b4d5fa0e86655acf94cb0412cc91278fa5917cdc0c0be08e19086"
    sha256 cellar: :any, arm64_tahoe:       "01da61bc5fd988294932c5fcf0843eb9902b781c73fc25acd040036f6203e85e"
    sha256 cellar: :any, arm64_sequoia:     "aedd74fa570f6e47c0e49e8fb716450cf275513c16787465708336bd1b188674"
    sha256 cellar: :any, arm64_linux:       "32eebdeb3dd6e2ac3e2a0d0835a56b12d6d245441551289786c6ac4eb30bce22"
    sha256 cellar: :any, x86_64_linux:      "e3e8dd26e3af50e6af756a0d794a7b094110e910816f4948c6d1d8685e6e7f92"
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
  depends_on "openssl@4"

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

  allow_network_access! :test

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
