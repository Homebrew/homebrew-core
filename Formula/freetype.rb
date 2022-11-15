class Freetype < Formula
  desc "Software library to render fonts"
  homepage "https://www.freetype.org/"
  url "https://downloads.sourceforge.net/project/freetype/freetype2/2.12.1/freetype-2.12.1.tar.xz"
  mirror "https://download.savannah.gnu.org/releases/freetype/freetype-2.12.1.tar.xz"
  sha256 "4766f20157cc4cf0cd292f80bf917f92d1c439b243ac3018debf6b9140c41a7f"
  license "FTL"

  livecheck do
    url :stable
    regex(/url=.*?freetype[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f91e2b53f5f3753508ba81d17a01974285b90696033053837fbe20aac876883f"
    sha256 cellar: :any,                 arm64_monterey: "3e190f2fa02702aa86e46cf33e7dde1d93e879f1de38f3d1b61e301f8367136d"
    sha256 cellar: :any,                 arm64_big_sur:  "deb09510fb83adf76d9bb0d4ac4a3d3a2ddfff0d0154e09d3719edb73b058278"
    sha256 cellar: :any,                 ventura:        "845ec00b1ba8e57841751de476e9f706536ed54c5d38fa10e8c0b0329a69b5f1"
    sha256 cellar: :any,                 monterey:       "3d4afd3f040571ea464c7afc010be38faf77665f919a79f557369d2eceee13d1"
    sha256 cellar: :any,                 big_sur:        "69a5d61245af56e6b088986b16c6e5b842c3d4f5896c34e013341ca94f4a45d1"
    sha256 cellar: :any,                 catalina:       "cafa6fee3a0ca54b1659f433667a145acef2c2d2061292d2f8bc088db7f0ea4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "43be70d09e51402bb453d491d69021af20f0d0c5154092bd5571b365673d4e2f"
  end

  depends_on "libpng"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
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
