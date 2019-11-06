class Fastme < Formula
  desc "Accurate and fast distance-based phylogeny inference program"
  homepage "http://www.atgc-montpellier.fr/fastme/"
  url "https://gite.lirmm.fr/atgc/FastME/raw/v2.1.6.1/tarball/fastme-2.1.6.1.tar.gz"
  sha256 "ac05853bc246ccb3d88b8bc075709a82cfe096331b0f4682b639f37df2b30974"
  revision 1

  bottle do
    cellar :any
    sha256 "2d77addf56ac300c3b219b1716b81d1fe1a04ee1759a79cab4d59aeee676a4ec" => :catalina
    sha256 "65bfd93ee6bdc21881fe342dd289a4c0808a3eb0abb1e04e174c32fd43a0bc77" => :mojave
    sha256 "eac83026ed4ce4b30511c1f7b79ff032e9c3c607a52d63881951937e210d663c" => :high_sierra
    sha256 "1a04d48b4a33ad3c854a4d45724f339438455f47e20d870c265b070ec75db08b" => :sierra
  end

  depends_on "gcc"

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
