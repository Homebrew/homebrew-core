class Kallisto < Formula
  desc "Quantify abundances of transcripts from RNA-Seq data"
  homepage "https://pachterlab.github.io/kallisto/"
  url "https://github.com/pachterlab/kallisto/archive/v0.45.0.tar.gz"
  sha256 "42cf3949065e286e0a184586e160a909d7660825dbbb25ca350cb1dd82aafa57"

  bottle do
    cellar :any
    sha256 "b8cae9afc8e18cceb114b84ecd53f24e3b00b803589b125eda5f6307e364e0a8" => :mojave
    sha256 "127c2e5aae118640a218e8141e441d649b900d4acf554cf3059e921c3dff262e" => :high_sierra
    sha256 "f865065a6ce9703669d5af9447a681e5a248b23da4a974ff49a57ece7e6f159a" => :sierra
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
