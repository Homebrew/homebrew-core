class Nudoku < Formula
  desc "Ncurses based sudoku game"
  homepage "https://jubalh.github.io/nudoku/"
  url "https://github.com/jubalh/nudoku/archive/refs/tags/4.0.1.tar.gz"
  sha256 "070dc06d9dad2a436fd44ff52a24f51c2522b13cc68e3d97765f4357f4dfc3d8"
  license "GPL-3.0-or-later"
  head "https://github.com/jubalh/nudoku.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:   "0af8b4c36a68855242d8c6b5c11edafa23d95b99f01c75ff5afe5e363fc5ffdf"
    sha256 arm64_ventura:  "d36571bdc6681967b1b4c4415749977df1cf546dfe6e7497144ceb7dece98b26"
    sha256 arm64_monterey: "b497e4ceb353928460e9a4b0d68d4cea8beefd949ac12997e24c830e74e47d59"
    sha256 sonoma:         "0fff4919f933d9b8a591945215e69af29ebfc388d9ee3daad5ce8fdf2ba6cafa"
    sha256 ventura:        "04242eff8300d13cb0a02454eb9499283995ae5694c32d4b4f5422abc9eb04bd"
    sha256 monterey:       "03f8f7201d2d950ae6b02ae3cf6a29e55424af8942447801d0b5ba9a440c8ec1"
    sha256 x86_64_linux:   "f7ba800fdbd5b5aeeba031362afb606cde57e93d1763c581212084793a23c267"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "gettext"

  uses_from_macos "ncurses"

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--enable-cairo",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "nudoku version #{version}", shell_output("#{bin}/nudoku -v")
  end
end
