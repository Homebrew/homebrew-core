class Agedu < Formula
  desc "Unix utility for tracking down wasted disk space"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/agedu/"
  url "https://www.chiark.greenend.org.uk/~sgtatham/agedu/agedu-20180522.5b12791.tar.gz"
  version "20180522"
  sha256 "151f3c9ebf0580d85e30870c473e675762c8537d5ce9df82a5ea3c86b3e5092e"
  head "https://git.tartarus.org/simon/agedu.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "548adc9dbfd21f676ab8435accd7551827b2e3fd9a204080230cc77e3d13d782" => :high_sierra
    sha256 "88c142e0214389e4fd67b4d537bec066801bb265301531ebb1996427828417cd" => :sierra
    sha256 "aeccf231645d2c6f7eaef3f3852251cd4052b0a946b2268c5a18737ebd34b5e4" => :el_capitan
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
