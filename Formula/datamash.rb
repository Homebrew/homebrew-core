class Datamash < Formula
  desc "Tool to perform numerical, textual & statistical operations"
  homepage "https://www.gnu.org/software/datamash"
  url "https://ftp.gnu.org/gnu/datamash/datamash-1.3.tar.gz"
  mirror "https://ftpmirror.gnu.org/datamash/datamash-1.3.tar.gz"
  sha256 "eebb52171a4353aaad01921384098cf54eb96ebfaf99660e017f6d9fc96657a6"

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
