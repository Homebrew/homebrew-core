class Agedu < Formula
  desc "Unix utility for tracking down wasted disk space"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/agedu/"
  url "https://www.chiark.greenend.org.uk/~sgtatham/agedu/agedu-20171202.8a8299e.tar.gz"
  version "20171202"
  sha256 "802727910f94d70306951f817772e873d1f83376aae05d16df3a120e384d043e"
  head "https://git.tartarus.org/simon/agedu.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ffc34134229c14b1fe7d65fa01c90724715228738aecfef82cdb8f79be1550ef" => :high_sierra
    sha256 "05d4afaee3fa14b005a7a4bab7c1c13b6d704b834fdd2f0ff63bb22721f1cb24" => :sierra
    sha256 "ccba7a5902c861069e5bc82e565c34857cffaf98c408145d2b3917d23319bc61" => :el_capitan
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
