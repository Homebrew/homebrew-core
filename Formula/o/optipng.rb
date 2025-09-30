class Optipng < Formula
  desc "PNG file optimizer"
  homepage "https://optipng.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/optipng/OptiPNG/optipng-7.9.1/optipng-7.9.1.tar.gz"
  sha256 "c2579be58c2c66dae9d63154edcb3d427fef64cb00ec0aff079c9d156ec46f29"
  license "Zlib"
  head "https://git.code.sf.net/p/optipng/code.git", branch: "tmp/main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c84699200d7b820ddfa07875d5f5be83cf6e4dd3497385919c46e748a4a8fdd8"
    sha256 cellar: :any,                 arm64_sequoia: "c2d204ed132d5c5268baf7b464e862e8201a5f80e0d3aa5891204ccccbdca28a"
    sha256 cellar: :any,                 arm64_sonoma:  "789d6ad60ed2c65a9c40850dc8401afd8c1c47239839a0b029bb1439f90bb3b7"
    sha256 cellar: :any,                 arm64_ventura: "ff5edc78c0cc6a0541b1d1b5fe095df0bd0d577dd01e490e9552ed2af60bd967"
    sha256 cellar: :any,                 sonoma:        "8499bb0e6d795f1c3f52af1da26a10a67b97b75dd6b25a976d965e89d53ce549"
    sha256 cellar: :any,                 ventura:       "df8d6959a9682204ddcdef2c02a74c4267f6ff65940fcf330d23e5ccfdb633fd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "babd33fb7d35adccc72a42b31dd796df7be85815b674bb2db204e3acce18fdb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd98dd54abf31da17c715505cd41351ceceb394a01b9927fc9454f08463e9aa6"
  end

  depends_on "libpng"

  uses_from_macos "zlib"

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
