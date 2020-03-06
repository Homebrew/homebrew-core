class Nudoku < Formula
  desc "Ncurses based sudoku game"
  homepage "https://jubalh.github.io/nudoku/"
  url "https://github.com/jubalh/nudoku/archive/2.0.0.tar.gz"
  sha256 "44d3ec1ff34a010910ac7a92f6d84e8a7a4678a966999b7be27d224609ae54e1"
  head "https://github.com/jubalh/nudoku.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "849d95cd3bcad09b584a0b692cd7982a31f3e455ec47bc888e13309650cfacb3" => :catalina
    sha256 "d82e9887a876b3762c2f676c95e36fbf5b98bc4306f584618397c0fb30c97f46" => :mojave
    sha256 "b6a14adadee0fb01f92397a5fdc31189492468e3d87875bed408ca41824d09b4" => :high_sierra
    sha256 "d4cea1e1c0f97655feb301910aa70c65a223959ba39a8493f31ca1a614eec175" => :sierra
    sha256 "8f4cd53a9cd87ac8b9b1b48a986329708134608e3ff4423e8f449e1a6c81d6f1" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"

  uses_from_macos "ncurses"

  # gettext 0.20 compatibility.
  # Remove with next release.
  patch do
    url "https://github.com/jubalh/nudoku/commit/9a4ffc359fe72f6af0e3654ae19ae421ab941ea8.patch?full_index=1"
    sha256 "e4b52f5ac48bfd192f28ae4b3a2fb146c7bc1bec1a441e8e10f4ad90550d4e66"
  end

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
