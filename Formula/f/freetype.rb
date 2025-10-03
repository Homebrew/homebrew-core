class Freetype < Formula
  desc "Software library to render fonts"
  homepage "https://www.freetype.org/"
  url "https://downloads.sourceforge.net/project/freetype/freetype2/2.14.1/freetype-2.14.1.tar.xz"
  mirror "https://download.savannah.gnu.org/releases/freetype/freetype-2.14.1.tar.xz"
  sha256 "32427e8c471ac095853212a37aef816c60b42052d4d9e48230bab3bdf2936ccc"
  license "FTL"
  revision 1

  livecheck do
    url :stable
    regex(/url=.*?freetype[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "33b2a967733994fd678f729cce118263f826e46056928d8ae4f816e746a394ae"
    sha256 cellar: :any,                 arm64_sequoia: "40c5e9659d92bf629661a6580fbbf7f962cb98b81ac982dbfa23d30e4ddaf6d7"
    sha256 cellar: :any,                 arm64_sonoma:  "eecba82b6352f8a953a8ebbbb340b82a5a6e1bb111001b637790abf0079bd63a"
    sha256 cellar: :any,                 sonoma:        "600186586fab89dec45ca8e4da1ca6bf00576326fb43b311ff9f705105a6df2e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "98a9c56c8d46c5d7bd420d2570d79a23f6a7995a44e64e5ad48168b7a687ff06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1ac27d046ced62aa0b41ed4087e91b56fcd01299f7a760a944ec0260b9001983"
  end

  depends_on "gnu-sed" => :build
  depends_on "pkgconf" => :build
  depends_on "libpng"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    # https://gitlab.freedesktop.org/freetype/freetype/-/issues/1358
    ENV.prepend_path "PATH", Formula["gnu-sed"].opt_libexec/"gnubin"

    # This file will be installed to bindir, so we want to avoid embedding the
    # absolute path to the pkg-config shim.
    inreplace "builds/unix/freetype-config.in", "%PKG_CONFIG%", "pkg-config"

    system "./configure", "--prefix=#{prefix}",
                          "--enable-freetype-config",
                          "--without-harfbuzz"
    system "make"
    system "make", "install"

    inreplace [bin/"freetype-config", lib/"pkgconfig/freetype2.pc"],
      prefix, opt_prefix
  end

  test do
    system bin/"freetype-config", "--cflags", "--libs", "--ftversion",
                                  "--exec-prefix", "--prefix"
  end
end
