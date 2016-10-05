class Dieharder < Formula
  desc "Random number test suite"
  homepage "https://www.phy.duke.edu/~rgb/General/dieharder.php"
  url "https://www.phy.duke.edu/~rgb/General/dieharder/dieharder-3.31.1.tgz"
  sha256 "6cff0ff8394c553549ac7433359ccfc955fb26794260314620dfa5e4cd4b727f"
  revision 1

  bottle do
    cellar :any
    sha256 "6970071bd722a3bbca3892ec4101d06b59461fb9ab3d47aebf71e8ce9d750cd4" => :sierra
    sha256 "ee6c8f5dd87948423016574258755ea42a01f55c38e81bbf6dc3d35d5cf0d733" => :el_capitan
    sha256 "6bf47d1e141f260abcf8926d75c82ff7ae45e582cb1af79fc984a849d9a08f71" => :yosemite
    sha256 "3a1fafb4843d5a16798b9a9375446b52bffb7f9a0516884b444d7e8a4d4adc24" => :mavericks
  end

  depends_on "gsl"

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-shared"
    system "make", "install"
  end

  test do
    system "#{bin}/dieharder", "-o", "-t", "10"
  end
end
