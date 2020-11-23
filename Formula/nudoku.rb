class Nudoku < Formula
  desc "Ncurses based sudoku game"
  homepage "https://jubalh.github.io/nudoku/"
  url "https://github.com/jubalh/nudoku/archive/2.1.0.tar.gz"
  sha256 "eeff7f3adea5bfe7b88bf7683d68e9a597aabd1442d1621f21760c746400b924"
  license "GPL-3.0-or-later"
  head "https://github.com/jubalh/nudoku.git"

  bottle do
    rebuild 1
    sha256 "f0ea69399c3ccabfe0c0dcf8da90ed52f046ec2b5f3bc4eb1077abd96bc14bc2" => :big_sur
    sha256 "6d6fd028d5f9eea08b6bd26446bd72ed953f79c47f17f80dcb211e5b53ebee21" => :catalina
    sha256 "25f52f7ccbc931c34d2af3c89902dcaa7ea47cab5c0e61d62890532f4fc7c036" => :mojave
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"

  uses_from_macos "ncurses"

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
