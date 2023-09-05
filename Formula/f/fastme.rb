class Fastme < Formula
  desc "Accurate and fast distance-based phylogeny inference program"
  homepage "http://www.atgc-montpellier.fr/fastme/"
  url "https://gite.lirmm.fr/atgc/FastME/raw/v2.1.6.3/tarball/fastme-2.1.6.3.tar.gz"
  sha256 "09a23ea94e23c0821ab75f426b410ec701dac47da841943587443a25b2b85030"
  revision 1

  livecheck do
    url "https://gite.lirmm.fr/atgc/FastME.git"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "2fd457f0c0d96cca6a317824fb8feb6beb3ff7f0af1592f957e405e69ef54014"
    sha256 cellar: :any,                 arm64_monterey: "e7530d4c95fba744512d6855a3c7fe472530274842a0e32b36fef471b5e36905"
    sha256 cellar: :any,                 arm64_big_sur:  "52c11335206aa05d8be9dc67fb4b13bd2fffa40d0bf6cefcb68ac11e29a42864"
    sha256 cellar: :any,                 ventura:        "60b489e83afeca87e9977df7d857d0f89fa229a042726a8c45c8711a9f295f95"
    sha256 cellar: :any,                 monterey:       "fb8ceaba186e055830afb68ecab9a13d1da3e067a6d3043fcddcd193c4a72026"
    sha256 cellar: :any,                 big_sur:        "6e2d00da0651530516a3e2ed929325f70af957e4d54ca522ca6601df256170bd"
    sha256 cellar: :any,                 catalina:       "7554de7489c8f3c360b8ab09641f48e66638d1b8472dddbede8c017a1552cb25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b4189a84d30c562933f974b932eccadd0d18115bdafa12241f0207ddd5c2d7d"
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
