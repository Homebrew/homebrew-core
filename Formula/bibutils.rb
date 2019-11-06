class Bibutils < Formula
  desc "Bibliography conversion utilities"
  homepage "https://sourceforge.net/p/bibutils/home/Bibutils/"
  url "https://downloads.sourceforge.net/project/bibutils/bibutils_6.7_src.tgz"
  sha256 "02a12b86ae5f1c4991d625aa4d982418bdfb4a8b5855ce1c0dd38a6436ac4c1c"

  bottle do
    cellar :any_skip_relocation
    sha256 "c9468806b3c51e20497707ffbd6b5d65880fb7016d9b8fe0f34efca96a34739f" => :catalina
    sha256 "77c7e24e44776095769e2103d7bc37ebbd314e91c6c86a9a4e24ad42f15b16dd" => :mojave
    sha256 "cf925ae310688ae93b2f93a4bb23deb16f06fa8f28f20b67aee17162eaa484c1" => :high_sierra
    sha256 "97a7c39fa603ac3ebdbde752b0b34d55bc724df248c8ecc8293e9cf47a791823" => :sierra
    sha256 "b0c558be47dbda2db57b3f13dcf830c37efcef97a5af1899aa3910027c9cdbed" => :el_capitan
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
