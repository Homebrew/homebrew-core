class Esniper < Formula
  desc "Snipe eBay auctions from the command-line"
  homepage "https://sourceforge.net/projects/esniper/"
  url "https://downloads.sourceforge.net/project/esniper/esniper/2.33.0/esniper-2-33-0.tgz"
  version "2.33"
  sha256 "c9b8b10aefe5c397d7dee4c569f87f227c6710de528b1dc402379e5b4f1793dd"

  bottle do
    cellar :any_skip_relocation
    sha256 "516cee5b3ad5ccf298d1ea1ffd08dfc41797fcd9825731ec2195bab883b62672" => :sierra
    sha256 "05f57d9df03fa24390a1190bfc3aadef1e8f09a32a9dc4b3ace5e3637ac6923d" => :el_capitan
    sha256 "4eaa6dd8bc13834672af94e4bdea01bcf08eef2aba15cd74b5fbbc65c6121ffd" => :yosemite
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
