class Fastme < Formula
  desc "Accurate and fast distance-based phylogeny inference program"
  homepage "http://www.atgc-montpellier.fr/fastme/"
  url "https://gite.lirmm.fr/atgc/FastME/raw/v2.1.6.3/tarball/fastme-2.1.6.3.tar.gz"
  sha256 "09a23ea94e23c0821ab75f426b410ec701dac47da841943587443a25b2b85030"

  livecheck do
    url "https://gite.lirmm.fr/atgc/FastME.git"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "6e0fd9ad8eee1ab92cb0e5a0046d7b1467a31d3d146240bb57f0c0d14b46d0bd"
    sha256                               arm64_big_sur:  "a63f7a94429ad21604091dbec3fa347d83c81f335a0e112e3a601975c26593f3"
    sha256 cellar: :any,                 monterey:       "586078e0500477eb8e7c1cfaaa3a660a059ba86f5e87a3c0bfd35753ae02a933"
    sha256 cellar: :any,                 big_sur:        "57efef94306e3b9dcbaa2b91289951b545b4ae49cdfe14fb444903e145485a49"
    sha256 cellar: :any,                 catalina:       "0024bfdb601cd133d2d7a544fa04bb8ad6650f846eba08310a7d69458432d591"
    sha256 cellar: :any,                 mojave:         "a685f1feb457d32b6df4444edec59913957347ae5bb3e3374ffedf334d07b210"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cbe637bb7191480a174baa1ad2cce6d15d68f6d1f68b807b6d16b0b7c670b4e9"
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
