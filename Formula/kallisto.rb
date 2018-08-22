class Kallisto < Formula
  desc "Quantify abundances of transcripts from RNA-Seq data"
  homepage "https://pachterlab.github.io/kallisto/"
  url "https://github.com/pachterlab/kallisto/archive/v0.44.0.tar.gz"
  sha256 "35a81201a56f4557697e6fe693dc6b701bbbd0a7b2b6e1c6c845ef816d67ca29"
  revision 1

  bottle do
    cellar :any
    sha256 "2b4aa9e98aaa90703a678a425e1986a05ef2aad15a6ae5e1809fee4d99c6a909" => :mojave
    sha256 "ab38b73fea94b87a8bb4a177a0c8d521bf91d5cd5476cd5b0237f2ea007ebefd" => :high_sierra
    sha256 "aae08244ae475a38fe28b7d33b1ce48880f48e3905451e813ba88c9bf69eda77" => :sierra
    sha256 "de0c2d1d3ec0b36aae9a536e890dab249bba372f26d6e72dc70d39e5ea3d29e9" => :el_capitan
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
