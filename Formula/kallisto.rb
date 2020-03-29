class Kallisto < Formula
  desc "Quantify abundances of transcripts from RNA-Seq data"
  homepage "https://pachterlab.github.io/kallisto/"
  url "https://github.com/pachterlab/kallisto/archive/v0.46.2.tar.gz"
  sha256 "c447ca8ddc40fcbd7d877d7c868bc8b72807aa8823a8a8d659e19bdd515baaf2"

  bottle do
    cellar :any_skip_relocation
    sha256 "7ef1f941663072b0a57597992acf8203ba3664129f305cb8626c0c346e51bf0c" => :catalina
    sha256 "b2e59c1cc0fc1b07d02bab1cbc1533bcca1edf4bc0b81791d5ac597a7b84cce0" => :mojave
    sha256 "8491424ec8d4f8e170315e13c5f3bb92895b608c9c7108f260459e06bbbf73f9" => :high_sierra
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
