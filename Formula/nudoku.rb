class Nudoku < Formula
  desc "Ncurses based sudoku game"
  homepage "https://jubalh.github.io/nudoku/"
  url "https://github.com/jubalh/nudoku/archive/2.1.0.tar.gz"
  sha256 "eeff7f3adea5bfe7b88bf7683d68e9a597aabd1442d1621f21760c746400b924"
  license "GPL-3.0-or-later"
  revision 1
  head "https://github.com/jubalh/nudoku.git", branch: "master"

  bottle do
    sha256 arm64_ventura:  "7af32212d5adb183528f350950913d31cb9de5644c1d8af158eef5b68bfc00de"
    sha256 arm64_monterey: "b1bf18647b1f42eb7dce94d90649f314d99be5575fbc417c103a94cc9282b3b5"
    sha256 arm64_big_sur:  "6350cd17943ce3a889f193d13ca662ffdc19eef6bfa38dc5e0f97b7a193e48b9"
    sha256 ventura:        "414db0599466260fc27e629e4f325d9bc33e6fb30f37cb99c07bcf3b450d99c8"
    sha256 monterey:       "8f296f4c8b2f0352e5ed7c492536c38f26c604c82c9a604559e17b75e9038685"
    sha256 big_sur:        "83449b550966a303d2095e8232d98d629abccced9f104442ca7d24ec102e1d3d"
    sha256 x86_64_linux:   "ae2f2e43eb521a04f347c59288bb2a9c68bfa8e95d2e06fa33e53e5dac693c56"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "gettext"

  uses_from_macos "ncurses"

  def install
    system "autoreconf", "-fiv"
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
