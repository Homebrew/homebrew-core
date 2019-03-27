class Datamash < Formula
  desc "Tool to perform numerical, textual & statistical operations"
  homepage "https://www.gnu.org/software/datamash"
  url "https://ftp.gnu.org/gnu/datamash/datamash-1.4.tar.gz"
  mirror "https://ftpmirror.gnu.org/datamash/datamash-1.4.tar.gz"
  sha256 "fa44dd2d5456bcb94ef49dfc6cfe62c83fd53ac435119a85d34e6812f6e6472a"

  bottle do
    cellar :any_skip_relocation
    sha256 "2f62847e83bb67f3637a924ed2f9bac2704c4b2694855a38ff5cc7bb8f9aaa7b" => :mojave
    sha256 "46375109fe618b238ce55f363a4ff37e1f02519446272b1164feacf7bd5614a4" => :high_sierra
    sha256 "9e2c6fb923dae81c0969ec63851c520c9b74fc9160a2b884a228e23afccee9c7" => :sierra
    sha256 "e8cee270f739abd46bea4dde5ae139b858e49cabacd4265b4d39b41a4c03eb1a" => :el_capitan
  end

  head do
    url "https://git.savannah.gnu.org/git/datamash.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
  end

  def install
    system "./bootstrap" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_equal "55", shell_output("seq 10 | #{bin}/datamash sum 1").chomp
  end
end
