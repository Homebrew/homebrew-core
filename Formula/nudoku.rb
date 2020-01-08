class Nudoku < Formula
  desc "ncurses based sudoku game"
  homepage "https://jubalh.github.io/nudoku/"
  url "https://github.com/jubalh/nudoku/archive/1.0.0.tar.gz"
  sha256 "80fb9996c28642920951c20cfd5ca6e370d75240255bc6f11067ae68b6e44eca"

  bottle do
    cellar :any_skip_relocation
    sha256 "849d95cd3bcad09b584a0b692cd7982a31f3e455ec47bc888e13309650cfacb3" => :catalina
    sha256 "d82e9887a876b3762c2f676c95e36fbf5b98bc4306f584618397c0fb30c97f46" => :mojave
    sha256 "b6a14adadee0fb01f92397a5fdc31189492468e3d87875bed408ca41824d09b4" => :high_sierra
    sha256 "d4cea1e1c0f97655feb301910aa70c65a223959ba39a8493f31ca1a614eec175" => :sierra
    sha256 "8f4cd53a9cd87ac8b9b1b48a986329708134608e3ff4423e8f449e1a6c81d6f1" => :el_capitan
  end

  head do
    url "https://github.com/jubalh/nudoku.git"

    depends_on "gettext" => :build
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    system "autoreconf", "-fiv"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "nudoku version #{version}", shell_output("#{bin}/nudoku -v")
  end
end
