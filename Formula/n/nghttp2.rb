class Nghttp2 < Formula
  desc "HTTP/2 C Library"
  homepage "https://nghttp2.org/"
  url "https://github.com/nghttp2/nghttp2/releases/download/v1.71.0/nghttp2-1.71.0.tar.gz"
  sha256 "0cdd35ecec77919b4b7b245f87fe8d2216e3d62da854eb0838c594ff058042fc"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "9eca791b58c36581a2e9d6960a51792a3ba055ac8b900ba2940fd6559e63384b"
    sha256 cellar: :any, arm64_tahoe:       "b701875e69912dd316679f30b3fd1ddb62f5761b530ed6f124f9d1cf2b569804"
    sha256 cellar: :any, arm64_sequoia:     "01614a6e82d92974b1a33d389fc68d4a35d4cdf89c47f67c9b29a0ac4c0ea2b7"
    sha256 cellar: :any, arm64_linux:       "58f27414ea1c7cd2cacc47b55dc4d15fa973cef8d1a65222432598387e2062f3"
    sha256 cellar: :any, x86_64_linux:      "21679ffccebfad6c3f8eaf20be17f7aa12c5387e7f55b48365a321ab3a00f787"
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
