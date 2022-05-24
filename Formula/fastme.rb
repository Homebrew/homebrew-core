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
    sha256 cellar: :any,                 arm64_monterey: "ae1a14a4c05375918caea9cfd1ca10dd9da88b03368008678a77f234c907637f"
    sha256 cellar: :any,                 arm64_big_sur:  "72fb7f3bf96eada63a931e8522a47d8ced80748908c36f4a38ab76004391a8ff"
    sha256 cellar: :any,                 monterey:       "55e99ea2feaf54910f1db7f060e3a52ae05d178d3e302c8fe89006088e4c7488"
    sha256 cellar: :any,                 big_sur:        "573b45beb5888133d6e5a2c276db19fec4cc6fbaf90c8ecf646a17d446775e00"
    sha256 cellar: :any,                 catalina:       "737b04e925c4b5260eb7ea21c4207dd5e4d8be2424edb0694c2bc71c09c86a59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2b47de3e8767c68a4cbb02e97a27ebd44eba20bca86a5c487a2a6edee29632c0"
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
