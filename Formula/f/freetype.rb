class Freetype < Formula
  desc "Software library to render fonts"
  homepage "https://www.freetype.org/"
  url "https://downloads.sourceforge.net/project/freetype/freetype2/2.14.3/freetype-2.14.3.tar.xz"
  mirror "https://download.savannah.gnu.org/releases/freetype/freetype-2.14.3.tar.xz"
  sha256 "36bc4f1cc413335368ee656c42afca65c5a3987e8768cc28cf11ba775e785a5f"
  license "FTL"
  compatibility_version 1

  livecheck do
    url :stable
    regex(/url=.*?freetype[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "449e22351da81ba5c8c398f87c295decac6b396bd6fab54becbb3d18800b62d1"
    sha256 cellar: :any,                 arm64_sequoia: "905d44c655367754329e9fcc67630c71c03c527f5ee0d9c89794b21e9708b172"
    sha256 cellar: :any,                 arm64_sonoma:  "4aeceab2c37d3685dd0de24b737f07c33a1098eaf757eb24d8d8bbe6ed68d02d"
    sha256 cellar: :any,                 sonoma:        "c266877a4676016b189131c87355f3e9be0d5e0edbe3a464b5b6ef039945f199"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "65a5b757dc5949a7d0bcbd86f3ecfc9571b2baca626846d73d214932d0240083"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4dfd17e1b578e43e2200b48b3b6745e18280df3ce9c9504f365f1bcc8fe8869e"
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
