class Kallisto < Formula
  desc "Quantify abundances of transcripts from RNA-Seq data"
  homepage "https://pachterlab.github.io/kallisto/"
  url "https://github.com/pachterlab/kallisto/archive/v0.46.0.tar.gz"
  sha256 "af4778cf121cdb9f732b355fc0ce44c6708caddf22d9560ba7f4b5d5b9795be1"

  bottle do
    cellar :any
    sha256 "05852bebacc999da35472f7455da91419f42b2efaa3ab302ceda138106d4d45e" => :catalina
    sha256 "c60e52bbe6e9dea2457a3a9f716ce9f06263ed28ce42d232bd0368f47e3d7fff" => :mojave
    sha256 "efc5fc1be9d62856d14337c62849c75e666ee9eff4743b746a768f04ade695ff" => :high_sierra
    sha256 "0db682761ce6b5c22d02fb54afbc76d7e2cd8b4fe49798fa1422ad535dfedcc8" => :sierra
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
