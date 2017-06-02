class Agedu < Formula
  desc "Unix utility for tracking down wasted disk space"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/agedu/"
  url "https://www.chiark.greenend.org.uk/~sgtatham/agedu/agedu-20160920.853cea9.tar.gz"
  version "20160920"
  sha256 "9c52eefe4932a4c07a30a79dbf2089982443817002ab9eabb478063113df5e18"
  head "https://git.tartarus.org/simon/agedu.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4ff7572c00d31b611a8fdadc1585a61f025bb4e771ffc339ef44ea6dc08e9c45" => :sierra
    sha256 "b5c035b2b8f931e7bb397851638809d4158d3c7a0f300decf4d8ded9ab10f7da" => :el_capitan
    sha256 "217536cf847038431c8469669c66ed63716aacb22cf4af29c93f88f2ebd2d39d" => :yosemite
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
    assert (testpath/"agedu.dat").exist?
  end
end
