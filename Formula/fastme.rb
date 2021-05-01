class Fastme < Formula
  desc "Accurate and fast distance-based phylogeny inference program"
  homepage "http://www.atgc-montpellier.fr/fastme/"
  url "https://gite.lirmm.fr/atgc/FastME/raw/v2.1.6.1/tarball/fastme-2.1.6.1.tar.gz"
  sha256 "ac05853bc246ccb3d88b8bc075709a82cfe096331b0f4682b639f37df2b30974"
  revision 3

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_big_sur: "100b27d15fd1bda9a876fd56185caed235f2f20f31a5a670ab02fd6a8252839d"
    sha256 cellar: :any, big_sur:       "10a92caf705c888801b6346013c04751ed19ae70b10ffd6894017c6856f56c7c"
    sha256 cellar: :any, catalina:      "0a6e916f7b223adef5ce24a90cf7e351a5839a47b345c328efcaacba5887bbee"
    sha256 cellar: :any, mojave:        "fa7cad5f28e354eaa64c312c20afdcb786fd7b52b5c5f3fa010df6003e7b388f"
  end

  on_macos do
    depends_on "gcc"
  end

  fails_with :clang # no OpenMP support

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.dist").write <<~EOS
      4
      A 0.0 1.0 2.0 4.0
      B 1.0 0.0 3.0 5.0
      C 2.0 3.0 0.0 6.0
      D 4.0 5.0 6.0 0.0
    EOS

    system "#{bin}/fastme", "-i", "test.dist"
    assert_predicate testpath/"test.dist_fastme_tree.nwk", :exist?
  end
end
