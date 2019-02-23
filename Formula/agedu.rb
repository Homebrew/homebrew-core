class Agedu < Formula
  desc "Unix utility for tracking down wasted disk space"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/agedu/"
  url "https://www.chiark.greenend.org.uk/~sgtatham/agedu/agedu-20180918.80c7beb.tar.gz"
  version "20180918"
  sha256 "26dc3cef8e64f6fe31491a22aa53048ccff59590f7fba4d0211b6fe0bd8c5a36"
  head "https://git.tartarus.org/simon/agedu.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c22495405a89ad5216eb562a0d69da0c33f152c8f35997eb7124f7096ffeb3c6" => :mojave
    sha256 "10f3a7572f0ac969a4c445fba43856ff5944cc31d6477bce45c840e4a71abb02" => :high_sierra
    sha256 "1b7e10c023c382650cb01de99d5e6b3a8dfcda34059d32f1c0ba2fc39c7d4591" => :sierra
    sha256 "f50ddaa6442d7676a3394636eb7c145d20d8d98b794e99ea774e317df36f25f4" => :el_capitan
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
