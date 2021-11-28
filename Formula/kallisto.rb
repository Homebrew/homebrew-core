class Kallisto < Formula
  desc "Quantify abundances of transcripts from RNA-Seq data"
  homepage "https://pachterlab.github.io/kallisto/"
  url "https://github.com/pachterlab/kallisto/archive/v0.46.2.tar.gz"
  sha256 "c447ca8ddc40fcbd7d877d7c868bc8b72807aa8823a8a8d659e19bdd515baaf2"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d7b9aff623b0268cfdf089a7869dd01eec0d7f54ca1e2bb065567e26296093f8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "51a7725f81265fe4530962417b874176e534f916cad432db1cb2d5c5840da3a6"
    sha256 cellar: :any_skip_relocation, monterey:       "f400337f4259327b35a0c1e0d779e3488aa9b26ae4a6c4a3a4275b3946279ca3"
    sha256 cellar: :any_skip_relocation, big_sur:        "2c004978635382869062996fed516c2edd83597d3e2221984759fc32955854e5"
    sha256 cellar: :any_skip_relocation, catalina:       "7ef1f941663072b0a57597992acf8203ba3664129f305cb8626c0c346e51bf0c"
    sha256 cellar: :any_skip_relocation, mojave:         "b2e59c1cc0fc1b07d02bab1cbc1533bcca1edf4bc0b81791d5ac597a7b84cce0"
    sha256 cellar: :any_skip_relocation, high_sierra:    "8491424ec8d4f8e170315e13c5f3bb92895b608c9c7108f260459e06bbbf73f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ca9d61869fb10b292f1ecc95329cb3905834e42a8d46cfc6b6bec177406b9b66"
  end

  depends_on "autoconf@2.69" => :build
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
