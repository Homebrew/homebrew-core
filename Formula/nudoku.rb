class Nudoku < Formula
  desc "ncurses based sudoku game"
  homepage "https://jubalh.github.io/nudoku/"
  url "https://github.com/jubalh/nudoku/releases/download/0.2.4/nudoku-0.2.4.tar.xz"
  sha256 "4a5c6ab215ed677e31b968f3aa0c418b91b4e643e4adfade543f533ce6cde53a"

  bottle do
    cellar :any_skip_relocation
    sha256 "ac37d01053c8eae43bd32d9ec94f6800597f369861dcde7b58830d177b00c65a" => :sierra
    sha256 "d4d1ff67b4e28496e3ce0458ed90802ac8833ebf1739e86265f05c9c4309ada5" => :el_capitan
    sha256 "7f1a30844a239c14e7c87b49b3ec4351320e7713682e1c12cb0804ec4a6dc5c7" => :yosemite
  end

  head do
    url "https://github.com/jubalh/nudoku.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  def install
    system "autoreconf", "-i" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match /nudoku version #{version}$/, shell_output("#{bin}/nudoku -v")
  end
end
