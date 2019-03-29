class Fastme < Formula
  desc "Accurate and fast distance-based phylogeny inference program"
  homepage "http://www.atgc-montpellier.fr/fastme/"
  url "https://gite.lirmm.fr/atgc/FastME/raw/v2.1.6.1/tarball/fastme-2.1.6.1.tar.gz"
  sha256 "ac05853bc246ccb3d88b8bc075709a82cfe096331b0f4682b639f37df2b30974"

  bottle do
    cellar :any
    sha256 "73408c497f0bbaaa108e017004874d6ea90a80bf55cb6ba7fc3f9f6c313c6fd8" => :mojave
    sha256 "693c79dce4bc3ac847eac8d355c4ecfd6d5b03b9db6ab6dd2b1ce662c98f3865" => :high_sierra
    sha256 "734cb3a22ba4926dc41a489e1d335509deef731b519b185ba188c02e2cc562cb" => :sierra
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
