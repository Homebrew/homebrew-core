class Bibutils < Formula
  desc "Bibliography conversion utilities"
  homepage "https://sourceforge.net/p/bibutils/home/Bibutils/"
  url "https://downloads.sourceforge.net/project/bibutils/bibutils_6.10_src.tgz"
  sha256 "8656c042fa1371443aa4e1a58bcab5fcea0b236eb39182e4004fc348ce56e496"

  bottle do
    cellar :any_skip_relocation
    sha256 "dac93b43ca23378a2479b3940ba06711ee75ec20448b8157f9c86e7793fa903e" => :catalina
    sha256 "581d652841aeef6824b5dbec7bd4d5d7ee6cb8681125d7588d23ebd28ed311df" => :mojave
    sha256 "6d10e1fe5b235d6b6027512eed4cb196c5a64db785f5df8dd4535a641d1010d8" => :high_sierra
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
