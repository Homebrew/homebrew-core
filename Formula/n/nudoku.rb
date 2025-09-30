class Nudoku < Formula
  desc "Ncurses based sudoku game"
  homepage "https://jubalh.github.io/nudoku/"
  url "https://github.com/jubalh/nudoku/archive/refs/tags/6.0.0.tar.gz"
  sha256 "98a80a58a15ea664dfa62e1e5ae51c737f9555ef114e483f3b3c2674d9c51495"
  license "GPL-3.0-or-later"
  head "https://github.com/jubalh/nudoku.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "9a56fa1b63e34c07c2ed2ce2dc5f95a875028e2b9edfc5f35df2367d9ecf9ac9"
    sha256 cellar: :any, arm64_sequoia: "ac02804b3879c3f1b602bd2c15f6f9a218b320f8fa3740cf2e355117022f4e54"
    sha256 cellar: :any, arm64_sonoma:  "6d2d2160e49788d703b0317dcddf47c81ce73e1c115f45c7a687d1cb8ec1526f"
    sha256 cellar: :any, arm64_ventura: "e000973d34179d396b9d66fe6892166d42994d912cff28749ffc3ae742282f82"
    sha256 cellar: :any, sonoma:        "70ae4545d5cd3f7fb9e72f2f65e48c1635588bccb16c377823797dffb2a51e4c"
    sha256 cellar: :any, ventura:       "bc735246db023afd1b83131222be7be992b484651937c15bf2857bc79acdb27d"
    sha256               arm64_linux:   "13766407355b1cd53c1c9926ee724d2a9c1b8307fcd68694e440640e8c962ac9"
    sha256               x86_64_linux:  "12f9fe670b01d9ad113eef3b94e0ac990f2210100b47bdf0f62b476bb43fd818"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkgconf" => :build
  depends_on "cairo"
  depends_on "gettext"

  uses_from_macos "ncurses"

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--disable-silent-rules",
                          "--enable-cairo",
                          *std_configure_args
    system "make", "install"
  end

  test do
    assert_match "nudoku version #{version}", shell_output("#{bin}/nudoku -v")
  end
end
