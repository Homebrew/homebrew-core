class Hamlib < Formula
  desc "Ham radio control libraries"
  homepage "http://www.hamlib.org/"
  url "https://github.com/Hamlib/Hamlib/releases/download/4.3/hamlib-4.3.tar.gz"
  sha256 "e26498125021b7a775607b215540ddbee637838e622e07fdb78d9832046b6c43"
  license "LGPL-2.1-or-later"
  head "https://github.com/hamlib/hamlib.git"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "bdec49de3605f8e035fabeda961319077f5f0dc3265c6776dbe44fbf4570e9e8"
    sha256 cellar: :any,                 big_sur:       "4e6f524ce4c83f681d6a4098d9fff73093a7193db7e31103a49c1372eb715b95"
    sha256 cellar: :any,                 catalina:      "9f88619f95c32128f55924b70ef0048f52a5b42331256e6ee420f447dac5cd8d"
    sha256 cellar: :any,                 mojave:        "230266b1312cdaa6945c42d07058665f89a83c15fafb2f6e303a230eb9b7cf1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3642c51c88f48864400359603fa5add507636df599d9845d6a17ff0d00815539"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "libtool"
  depends_on "libusb-compat"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  def install
    system "./bootstrap" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/rigctl", "-V"
  end
end
