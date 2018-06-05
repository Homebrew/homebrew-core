class Bibutils < Formula
  desc "Bibliography conversion utilities"
  homepage "https://sourceforge.net/p/bibutils/home/Bibutils/"
  url "https://downloads.sourceforge.net/project/bibutils/bibutils_6.3_src.tgz"
  sha256 "1e73ca908ef867e8282395c081d4fa4ddefaa8b95d3c83b781ad6bb87ad92583"

  bottle do
    cellar :any_skip_relocation
    sha256 "3a3bbfc99cc8fa1745ee68f974ab2de3b95259dc17dc3bba12f533ebccfb6156" => :high_sierra
    sha256 "8cf6d98679a31d08464c3d5351cb647d36984c31006822806f97c34420167837" => :sierra
    sha256 "0de88bf525c48769c2d8729787aac0571efbdcbd035f6f1e540350b31301fd7b" => :el_capitan
    sha256 "575f83b6e50e14095ea3add04428260a875812aa063fb335f12946d340820187" => :yosemite
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
