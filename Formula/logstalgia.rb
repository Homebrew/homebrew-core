class Logstalgia < Formula
  desc "Web server access log visualizer with retro style"
  homepage "https://logstalgia.io/"
  url "https://github.com/acaudwell/Logstalgia/releases/download/logstalgia-1.1.3/logstalgia-1.1.3.tar.gz"
  sha256 "82e6a33c3c305c1f1d32d7e115ba0b307bb191ed2a70368a3cd9138ced0a98d9"
  license "GPL-3.0"
  revision 1

  bottle do
    sha256 arm64_ventura:  "0995a316323b353da37e7127c74cc2e40c43cfba78eba1e2978f5738c2177ca3"
    sha256 arm64_monterey: "51b1ebf735b6c26e34fd57234ca790d26c717b4b9a9697ce5bceedd23254ccea"
    sha256 arm64_big_sur:  "2ec489672c5e729652dc221d3b8a6d328136c3250d06ee66ee4a6b565c316a95"
    sha256 ventura:        "c8561a8baf8e6a8aae4505c12d8817bc2f1fb92772edbf934d61eef1976e4b31"
    sha256 monterey:       "960950464fb35574b0231a78c4ed6c5bb5020966d001df95a1455c7862a7c8f5"
    sha256 big_sur:        "6e947997e8b1d5b617413dca058ea0ee75cf17f61b84a328fdc2d3812525c558"
    sha256 catalina:       "a74087e845875519b13535d3046cafe897f89e25a2993a17347ce1a898213486"
    sha256 x86_64_linux:   "28f069755a8b6f4d20b2aec317340fe9620d1251ef741ca6f6c983fb18ceed89"
  end

  head do
    url "https://github.com/acaudwell/Logstalgia.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "glm" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "freetype"
  depends_on "glew"
  depends_on "libpng"
  depends_on "pcre2"
  depends_on "sdl2"
  depends_on "sdl2_image"

  def install
    # clang on Mt. Lion will try to build against libstdc++,
    # despite -std=gnu++0x
    ENV.libcxx

    # For non-/usr/local installs
    ENV.append "CXXFLAGS", "-I#{HOMEBREW_PREFIX}/include"

    # Handle building head.
    system "autoreconf", "-f", "-i" if build.head?

    system "./configure", *std_configure_args,
                          "--with-boost-libdir=#{Formula["boost"].opt_lib}",
                          "--without-x"
    system "make"
    system "make", "install"
  end

  test do
    assert_match "Logstalgia v1.", shell_output("#{bin}/logstalgia --help")
  end
end
