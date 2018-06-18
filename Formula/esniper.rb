class Esniper < Formula
  desc "Snipe eBay auctions from the command-line"
  homepage "https://sourceforge.net/projects/esniper/"
  url "https://downloads.sourceforge.net/project/esniper/esniper/2.35.0/esniper-2-35-0.tgz"
  version "2.35.0"
  sha256 "a93d4533e31640554f2e430ac76b43e73a50ed6d721511066020712ac8923c12"

  bottle do
    cellar :any_skip_relocation
    sha256 "b927a60bc355aea6641292a89c6eaf26b913f5760057e4f41ecf491ba066d1a3" => :high_sierra
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
