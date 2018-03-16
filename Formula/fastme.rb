class Fastme < Formula
  desc "Accurate and fast distance-based phylogeny inference program"
  homepage "http://www.atgc-montpellier.fr/fastme/"
  url "https://gite.lirmm.fr/atgc/FastME/raw/v2.1.6/tarball/fastme-2.1.6.tar.gz"
  sha256 "4945c151e15acffd64820c5e1a4c4ed57ab9fada7f3fe84e3423c5155546b1d0"

  bottle do
    cellar :any
    sha256 "e9e0102fba2e0d74c7c1ad37963bfe8a7c721ab2544f4b372325d6d57173a483" => :high_sierra
    sha256 "b25aee32b3b7a1213b6cad7c224d53ab5c0a397082a68cf6e782f9e68c4b6a4c" => :sierra
    sha256 "834a5f609ef8e26d74f31cd495f9862469ec19401ab7dead0a09a675bcfed0d1" => :el_capitan
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
