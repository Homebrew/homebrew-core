class Optipng < Formula
  desc "PNG file optimizer"
  homepage "https://optipng.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/optipng/OptiPNG/optipng-7.9.1/optipng-7.9.1.tar.gz"
  sha256 "c2579be58c2c66dae9d63154edcb3d427fef64cb00ec0aff079c9d156ec46f29"
  license "Zlib"
  head "https://git.code.sf.net/p/optipng/code.git", branch: "tmp/main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "7bc1a16e16342def4b3cb3264737beaa1319d6487d812066d341b2d7e7652512"
    sha256 cellar: :any,                 arm64_sequoia: "04c60466375077fc2707c4b663c4557f684c2a5a0ad6492f16e6b20faa8c02f9"
    sha256 cellar: :any,                 arm64_sonoma:  "24a250dca1b1322b7f7bd3057752f92e5d77c232342c8e3649b10fbe1eb617f9"
    sha256 cellar: :any,                 sonoma:        "fce585cdebd10bee1694e8b44078da666cd5d1459634f8ac22a8202711254a55"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ad4fcb25fbeaa03ff1a1f53a22c4660ab127f14a6e2370814135bd645692500e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a0d382808f584669781d2c1bdc4db551cad72e10408669a4618db0f2e3532a67"
  end

  depends_on "libpng"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "./configure", "--with-system-zlib",
                          "--with-system-libpng",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    system bin/"optipng", "-simulate", test_fixtures("test.png")
  end
end
