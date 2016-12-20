
class Kollector < Formula
  desc "Targeted de novo Gene Assembly"
  homepage "https://github.com/bcgsc/kollector"
  url "https://github.com/bcgsc/kollector/archive/V1.0.tar.gz"
  version "1.0"
  sha256 "76dc3e03398ade0ae39b241943ce7dabcf65c09e3b30180726bfea574c462d15"
  #tag "bioinformatics"

  depends_on "abyss" => :build
  depends_on "biobloomtools" => :build
  depends_on "gmap-gsnap" => :build
  depends_on "samtools" => :build
  depends_on "bwa" => :build
  
  def install
   
    bin.install "./bin/kollector.sh"
    bin.install "./bin/kollector-recruit.mk"
    bin.install "./bin/kollector-extract.sh"
    bin.install "./bin/kollector_multiple.sh"
    doc.install "README.md"
    doc.install "LICENSE.txt"
    prefix.install "test"
    prefix.install "data"
    
  end

  test do
    assert_match "Usage", shell_output("#{bin}/kollector.sh", 255)
  end
end
