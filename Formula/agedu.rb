class Agedu < Formula
  desc "Unix utility for tracking down wasted disk space"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/agedu/"
  url "https://www.chiark.greenend.org.uk/~sgtatham/agedu/agedu-20190630.66cb14d.tar.gz"
  version "20190630"
  sha256 "717ee909bb9f737089857765713e39462db6169b99abd7587192e65b7554d5bb"
  head "https://git.tartarus.org/simon/agedu.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5396979e91e666e508f42292185a535ce7c05e2ab58cc737bd71cfa8a8075098" => :mojave
    sha256 "a2870dd2c261fb6b0b2e8f4737e3e78766ee81bfd4d91f5d866382ce926150d7" => :high_sierra
    sha256 "8faf747600ba2be25a29493dd51df0ff9faf9186c695db0472bad8bf28303575" => :sierra
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
