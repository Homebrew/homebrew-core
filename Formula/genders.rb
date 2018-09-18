class Genders < Formula
  desc "Static cluster configuration database for cluster management"
  homepage "https://computing.llnl.gov/linux/genders.html"
  url "https://downloads.sourceforge.net/project/genders/genders/1.22-1/genders-1.22.tar.gz"
  sha256 "0ff292825a29201106239c4d47d9ce4c6bda3f51c78c0463eb2634ecc337b774"

  bottle do
    cellar :any
    sha256 "ca1e1452a598fd313b76788262c762c75eadf975cc2a07fe49937823350acef9" => :mojave
    sha256 "67d6136a20f82c2e249d9b98ef2394bc98ae1ca40daec766255a4d1c67cbd8d8" => :high_sierra
    sha256 "af7991bf0459a88559c4a09a3be4fa96b26d17dea3750bc964f244c2754ffd0d" => :sierra
    sha256 "4d5c7ced8593d2571b06d076a16ccce0bfcc99a1ea3f314b3f5f0d09d18c6076" => :el_capitan
    sha256 "f4e7550bac6a7d427ada6d5af16b5e5bbae52786fbad1f673af1e296bace5343" => :yosemite
    sha256 "c455a536ad6b100887fbc6badf0e054157cf961ea02802f67a694c5e8dd30b96" => :mavericks
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--with-java-extensions=no"
    system "make", "install"
  end
end
