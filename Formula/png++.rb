class Pngxx < Formula
  desc "C++ wrapper for libpng library"
  homepage "https://www.nongnu.org/pngpp/"
  url "https://download.savannah.gnu.org/releases/pngpp/png++-0.2.9.tar.gz"
  sha256 "abbc6a0565122b6c402d61743451830b4faee6ece454601c5711e1c1b4238791"

  bottle do
    cellar :any_skip_relocation
    sha256 "0a5221ea49fb845c830698b2d1c170cb8d59d18916ca843a5c80ef7d48b37435" => :mojave
    sha256 "4085580bff1ec2116c321e84a426d195943a002f84b4662c9814a64e5925c627" => :high_sierra
    sha256 "41785b523dc50e5b237d83d027b34b6532114a6751eff3f409ee0ba9e0730f04" => :sierra
    sha256 "7b01b3ff0af9e60f2887bb45ff5ba2f5823a9a440c2d78e51e69904d3edd80d8" => :el_capitan
    sha256 "de37d7fadb7308b45ba0448308256d00bf36442bacbab1e734ee8398aea8a8dd" => :yosemite
    sha256 "f2e242ee428f191645418a9897eb2fd729408dd67d04e7af4cefc7dcb5715250" => :mavericks
  end

  depends_on "libpng"

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end
end
