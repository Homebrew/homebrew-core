class Nghttp2 < Formula
  desc "HTTP/2 C Library"
  homepage "https://nghttp2.org/"
  url "https://github.com/nghttp2/nghttp2/releases/download/v1.68.1/nghttp2-1.68.1.tar.gz"
  mirror "http://fresh-center.net/linux/www/nghttp2-1.68.1.tar.gz"
  sha256 "ceb434c1f9dfe2a9d305b6b797786fb9227484dfa88508d14ca1c50263db55d3"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f81a8883531828de7adf70d56055aa62ec0330bd3b36fa137e5fed621660c292"
    sha256 cellar: :any,                 arm64_sequoia: "477d3f318b64df6e5696dc9c8617d76cf4360b2c9d9f532a8498cefeb9ae90ea"
    sha256 cellar: :any,                 arm64_sonoma:  "b1bfeb7a05bb626b237d762cd71d4c33134e1718eb46a46b12dafafa438f1346"
    sha256 cellar: :any,                 sonoma:        "acb8c68c592c42de4982d973a751885ad01e65c88904d919d5965c8e5c0e3c46"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "88e1463f0dd01540e92e7db68e01d3fd97a33ba31d78ec4279695266203beda8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c369643d01639747a6af3b3fcc3fd40848ffa29c3e8b3e958bbb0a6f896ab172"
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
