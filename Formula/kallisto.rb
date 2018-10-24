class Kallisto < Formula
  desc "Quantify abundances of transcripts from RNA-Seq data"
  homepage "https://pachterlab.github.io/kallisto/"
  url "https://github.com/pachterlab/kallisto/archive/v0.44.0.tar.gz"
  sha256 "35a81201a56f4557697e6fe693dc6b701bbbd0a7b2b6e1c6c845ef816d67ca29"
  revision 3

  bottle do
    cellar :any
    sha256 "c3a61f791c9ebc848223f80c2da725db4842586437f53a0c721cefcf408c7dca" => :mojave
    sha256 "cc9ba346ad40d40bb06a9fd090d8831b8af565c5a260030f9925a3eb7bcbea56" => :high_sierra
    sha256 "f459b12833816a79fc35ab3336ad60de232c8531ad7f266403b1817ae2a9a245" => :sierra
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
