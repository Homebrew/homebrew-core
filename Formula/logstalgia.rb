class Logstalgia < Formula
  desc "Web server access log visualizer with retro style"
  homepage "https://logstalgia.io/"
  url "https://github.com/acaudwell/Logstalgia/releases/download/logstalgia-1.1.2/logstalgia-1.1.2.tar.gz"
  sha256 "ed3f4081e401f4a509761a7204bdbd7c34f8f1aff9dcb030348885fb3995fca9"

  bottle do
    sha256 "f5f0829a847376d5d5ae691c53de7b850c26d187631b8bfae8d5cecaf69d935b" => :mojave
    sha256 "3c70aaf704c6486a0820ad416e9b71be4ee80492fdfec509da494d95657ddc6d" => :high_sierra
    sha256 "bf1761008179e17ff019777b60dd498174532e8feb1d7044c78d84bddbec9864" => :sierra
    sha256 "98fd439fb47a282ef86a45568f337ff3195418d32459c6e16718d1748e5f23f7" => :el_capitan
  end

  head do
    url "https://github.com/acaudwell/Logstalgia.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "boost" => :build
  depends_on "glm" => :build
  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "glew"
  depends_on "libpng"
  depends_on "pcre"
  depends_on "sdl2"
  depends_on "sdl2_image"

  needs :cxx11

  def install
    # clang on Mt. Lion will try to build against libstdc++,
    # despite -std=gnu++0x
    ENV.libcxx

    # For non-/usr/local installs
    ENV.append "CXXFLAGS", "-I#{HOMEBREW_PREFIX}/include"

    # Handle building head.
    system "autoreconf", "-f", "-i" if build.head?

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--without-x"
    system "make"
    system "make", "install"
  end

  test do
    assert_match "Logstalgia v1.", shell_output("#{bin}/logstalgia --help")
  end
end
