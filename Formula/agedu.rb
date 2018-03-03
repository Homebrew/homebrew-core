class Agedu < Formula
  desc "Unix utility for tracking down wasted disk space"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/agedu/"
  url "https://www.chiark.greenend.org.uk/~sgtatham/agedu/agedu-20180302.9421c00.tar.gz"
  version "20180302"
  sha256 "7dbe2efa2a054c61990dba26c948f8a3da99027493d3b53cd7cbfcad5d7a9cd0"
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
