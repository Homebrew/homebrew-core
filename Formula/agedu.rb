class Agedu < Formula
  desc "Unix utility for tracking down wasted disk space"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/agedu/"
  url "https://www.chiark.greenend.org.uk/~sgtatham/agedu/agedu-20180329.af641e6.tar.gz"
  version "20180329"
  sha256 "b39595fab26612dd29b820c7a0b02ac969cc1e943bcd8e280e2f46cf087da0fc"
  head "https://git.tartarus.org/simon/agedu.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9a376a1bef98f2c139311bc6d43d59ce3cf6fef0bad33e1e84b9120d0ecb0add" => :high_sierra
    sha256 "4ddefb70fa8fa3f3d9a1fcfb2cf217a834613dcedca1c80dd3798e8ddcea5fa4" => :sierra
    sha256 "ca4b04c6513234303c5120fa79d3ff1f4c58215ec6d86d8c2d9051ca784cc336" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "halibut" => :build

  def install
    system "./mkauto.sh"
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"agedu", "-s", "."
    assert_predicate testpath/"agedu.dat", :exist?
  end
end
