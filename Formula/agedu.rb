class Agedu < Formula
  desc "Unix utility for tracking down wasted disk space"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/agedu/"
  url "https://www.chiark.greenend.org.uk/~sgtatham/agedu/agedu-20190630.66cb14d.tar.gz"
  version "20190630"
  sha256 "717ee909bb9f737089857765713e39462db6169b99abd7587192e65b7554d5bb"
  head "https://git.tartarus.org/simon/agedu.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "cca96d256d3ec4eb7ccaa2e5062cf575bd3065d7068a9d6bd7e3508a7e87048d" => :catalina
    sha256 "3cec13de1853d543fd8bd42f578f1037e5005040638af2143bf38b3dd22a0060" => :mojave
    sha256 "5e6ba4f9a0e740e8091def5ffa43c8b88f841f0554fb721d92b43bff517500e0" => :high_sierra
    sha256 "bac281c68b7b62f7241f49567c29828c97e51990f54da8c208dfa206465716b4" => :sierra
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
