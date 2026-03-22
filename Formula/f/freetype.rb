class Freetype < Formula
  desc "Software library to render fonts"
  homepage "https://www.freetype.org/"
  url "https://downloads.sourceforge.net/project/freetype/freetype2/2.14.2/freetype-2.14.2.tar.xz"
  mirror "https://download.savannah.gnu.org/releases/freetype/freetype-2.14.2.tar.xz"
  sha256 "4b62dcab4c920a1a860369933221814362e699e26f55792516d671e6ff55b5e1"
  license "FTL"
  compatibility_version 1

  livecheck do
    url :stable
    regex(/url=.*?freetype[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0a6456b91679ce3fe560e78d36a92c2ed32acad819e60a011d308ef2ca6ffe1a"
    sha256 cellar: :any,                 arm64_sequoia: "1a8a920fdc994f0d3ffe1020e8b97782cc0ba4ea4017d3109f85c603ccc2b185"
    sha256 cellar: :any,                 arm64_sonoma:  "cd278332ace43fc2c55b2123159f53062ba563c7db6e272d226f0dea273f9849"
    sha256 cellar: :any,                 sonoma:        "a7872ee2b74cc83ff972afe6284d9bc54a59c8b7673722e1247d0be907fe1585"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "87dd61e4c0f0075448069ad16cba072fed4e908b525617c7e42f451f621274c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa7f81d1a77565eacc7f292ebefa6940aae860e0395b0fcb133fd4ac6e84e5a9"
  end

  depends_on "pkgconf" => :build
  depends_on "libpng"

  uses_from_macos "bzip2"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
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
