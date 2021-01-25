class Fastme < Formula
  desc "Accurate and fast distance-based phylogeny inference program"
  homepage "http://www.atgc-montpellier.fr/fastme/"
  url "https://gite.lirmm.fr/atgc/FastME/raw/v2.1.6.1/tarball/fastme-2.1.6.1.tar.gz"
  sha256 "ac05853bc246ccb3d88b8bc075709a82cfe096331b0f4682b639f37df2b30974"
  revision 2

  bottle do
    cellar :any
    sha256 "ce3fa9ef0eac119aebbdb0feb8f588c54ff423f1a0cdc1e0c0d489f19a86e745" => :big_sur
    sha256 "833dd8f14112444ba2131ea4d2213a4ebff23842882460139ae46e75ce6ce778" => :arm64_big_sur
    sha256 "ef8226e09481486fa3e047ee5145cfc0dc370fceaa702095b835ad701eebf9fe" => :catalina
    sha256 "517b3f8d0fe9b403b9de35ebca8af530f859a66ae788ee779e21b9d62e9c5c6f" => :mojave
    sha256 "25cf8eb54ef7416842036f83c99eebb5a5881267d642f4a2c84c94fb5892a511" => :high_sierra
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
