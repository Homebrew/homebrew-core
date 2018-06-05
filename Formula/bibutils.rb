class Bibutils < Formula
  desc "Bibliography conversion utilities"
  homepage "https://sourceforge.net/p/bibutils/home/Bibutils/"
  url "https://downloads.sourceforge.net/project/bibutils/bibutils_6.4_src.tgz"
  sha256 "19a4982559c78dbb6bd11337b0ed420bbeb1ed09b4f8d9a03115824e0cfa826a"

  bottle do
    cellar :any_skip_relocation
    sha256 "82716615310c4c751f7b281b6018125b428a037937e8ac9cccebcca3f1b5fcf3" => :high_sierra
    sha256 "be1d484ff0170a346daf5807d944e01adeb6942870791994d2704d6f5a296803" => :sierra
    sha256 "310608d5f9f8ba637f7446d43788cdf92feb8cd0157a25d188121dfa734b668c" => :el_capitan
  end

  def install
    system "./configure", "--install-dir", bin,
                          "--install-lib", lib
    system "make", "install", "CC=#{ENV.cc}"
  end

  test do
    (testpath/"test.bib").write <<~EOS
      @article{Homebrew,
          title   = {Something},
          author  = {Someone},
          journal = {Something},
          volume  = {1},
          number  = {2},
          pages   = {3--4}
      }
    EOS

    system "#{bin}/bib2xml", "test.bib"
  end
end
