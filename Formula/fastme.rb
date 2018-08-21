class Fastme < Formula
  desc "Accurate and fast distance-based phylogeny inference program"
  homepage "http://www.atgc-montpellier.fr/fastme/"
  url "https://gite.lirmm.fr/atgc/FastME/raw/v2.1.6/tarball/fastme-2.1.6.tar.gz"
  sha256 "4945c151e15acffd64820c5e1a4c4ed57ab9fada7f3fe84e3423c5155546b1d0"
  revision 1

  bottle do
    cellar :any
    sha256 "a00be7dee09d2fc69a2b7a63ba6178669922cd71e5ad386527948d9218270cd2" => :mojave
    sha256 "411f3b6aaa0ee9e1946d93e06a4eb6aec7e4e2b2e7d87f0deb0288e333635203" => :high_sierra
    sha256 "5a722e15df45cfe77a39ab5c7f226422e589aa071eabf9c98bc0b779b4980620" => :sierra
    sha256 "d4640b1d176234cb35c25ca3d9ad5dc318db840a1c0a79fc057b08a738a6147c" => :el_capitan
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
