class Freetype < Formula
  desc "Software library to render fonts"
  homepage "https://www.freetype.org/"
  url "https://downloads.sourceforge.net/project/freetype/freetype2/2.13.1/freetype-2.13.1.tar.xz"
  mirror "https://download.savannah.gnu.org/releases/freetype/freetype-2.13.1.tar.xz"
  sha256 "ea67e3b019b1104d1667aa274f5dc307d8cbd606b399bc32df308a77f1a564bf"
  license "FTL"

  livecheck do
    url :stable
    regex(/url=.*?freetype[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "87a44e9a361f9dcc531514c9e34b6da2893a4650c60419eed7331d8a92daa8a1"
    sha256 cellar: :any,                 arm64_monterey: "99f7cb3ebf9309e1734391611c7fab4b2dfe48fe2b0dc484f2e0476b913e958e"
    sha256 cellar: :any,                 arm64_big_sur:  "5aad113162129820c2926641a203db43139f0bf9dc2d7ae1b8f090ab29fb7011"
    sha256 cellar: :any,                 ventura:        "872745894238fce7dba35a0add31b49b7c53150d9b7ee22a010104f0795895d2"
    sha256 cellar: :any,                 monterey:       "57eae05744e50fab0dd3860af6b683bce245a65721e11d745c771432c5df0629"
    sha256 cellar: :any,                 big_sur:        "ae5f6d23acb94cd01039a950cdcc99917641fbdb1171f5aa3c78bafc5317c3c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "07fec4ca74409c33e6d572a7027040a4acbd72527b4eb0a21e5d7e734fbcb7f0"
  end

  depends_on "pkg-config" => :build
  depends_on "libpng"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

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
