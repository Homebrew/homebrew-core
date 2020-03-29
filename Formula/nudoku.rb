class Nudoku < Formula
  desc "Ncurses based sudoku game"
  homepage "https://jubalh.github.io/nudoku/"
  url "https://github.com/jubalh/nudoku/archive/2.0.0.tar.gz"
  sha256 "44d3ec1ff34a010910ac7a92f6d84e8a7a4678a966999b7be27d224609ae54e1"
  head "https://github.com/jubalh/nudoku.git"

  bottle do
    sha256 "42af644b71eee33e827eb588221eddc0a2b16d552907f9bd80116177e91b748a" => :catalina
    sha256 "c31813e8e20e6a7f3869bd0869d21e24877ee15de9f00f7eaf812bc81244418f" => :mojave
    sha256 "fabdc0fc21df7b01f097ae89884d8234d8efe1a3b4335a4d2897f98df5291e67" => :high_sierra
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
