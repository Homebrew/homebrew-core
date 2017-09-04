class Agedu < Formula
  desc "Unix utility for tracking down wasted disk space"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/agedu/"
  url "https://www.chiark.greenend.org.uk/~sgtatham/agedu/agedu-20170831.fc6b2b5.tar.gz"
  version "20170831"
  sha256 "dd2e6f82270c5bf6083c0d275251207607d8b68955511b3083cec477279267bf"
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
