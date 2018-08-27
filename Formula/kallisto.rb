class Kallisto < Formula
  desc "Quantify abundances of transcripts from RNA-Seq data"
  homepage "https://pachterlab.github.io/kallisto/"
  url "https://github.com/pachterlab/kallisto/archive/v0.44.0.tar.gz"
  sha256 "35a81201a56f4557697e6fe693dc6b701bbbd0a7b2b6e1c6c845ef816d67ca29"
  revision 2

  bottle do
    cellar :any
    sha256 "f10b20c023f318b785d3e2b78e6b18a520a4362890d5357cf19b31bc5f7dd7c3" => :high_sierra
    sha256 "be0496a68404a00011e0081c07b27fbc99ab22eb7a6c5ed29ad46d186a36821d" => :sierra
    sha256 "f3ef4d856d3279ff8a891fe7ae1d443b66b1755388f52bf388c1779098b71639" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake" => :build
  depends_on "hdf5"

  def install
    # Upstream issue 15 Feb 2018 "cmake does not run autoreconf for htslib"
    # https://github.com/pachterlab/kallisto/issues/159
    system "autoreconf", "-fiv", "ext/htslib"

    system "cmake", ".", *std_cmake_args

    # Upstream issue 15 Feb 2018 "parallelized build failure"
    # https://github.com/pachterlab/kallisto/issues/160
    # Upstream issue 15 Feb 2018 "cannot use system htslib"
    # https://github.com/pachterlab/kallisto/issues/161
    system "make", "htslib"

    system "make", "install"
  end

  test do
    (testpath/"test.fasta").write <<~EOS
      >seq0
      FQTWEEFSRAAEKLYLADPMKVRVVLKYRHVDGNLCIKVTDDLVCLVYRTDQAQDVKKIEKF
    EOS
    output = shell_output("#{bin}/kallisto index -i test.index test.fasta 2>&1")
    assert_match "has 1 contigs and contains 32 k-mers", output
  end
end
