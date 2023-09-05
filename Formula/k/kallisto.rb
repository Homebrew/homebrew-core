class Kallisto < Formula
  desc "Quantify abundances of transcripts from RNA-Seq data"
  homepage "https://pachterlab.github.io/kallisto/"
  url "https://github.com/pachterlab/kallisto/archive/v0.50.0.tar.gz"
  sha256 "f9cc0058d08206cb6dde4a4dcaf8a778df5a939a6e021508eea9b00b0d6d5368"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b256f3c779c3921f006889df1a7e5471b34dd51ca92eedb229284c6663c2538d"
    sha256 cellar: :any,                 arm64_monterey: "a641d25d2867d075b408e4dd51c8f9e438b8eb7a575ee910c3d26e5207a4a9c8"
    sha256 cellar: :any,                 arm64_big_sur:  "b8037445c024eca5fa9747ca315c305f2559529abf9630cad0bf74094fac57c7"
    sha256 cellar: :any,                 ventura:        "2a274aa468fec02e86aeb5ce53fffcf6dbcbc751aeb2a8f25b3f0fa578abeae6"
    sha256 cellar: :any,                 monterey:       "c705153b7b85313979f9941f938481f9af98b32ee2c4a44b2e943a0804f20245"
    sha256 cellar: :any,                 big_sur:        "ca929c6f7dac9089af4f70ab5dc68d122968b817379ae317036b28664ff26dc6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "47a9332b96fb56256ef26ac2f73f9fa100d2f9ed0a8a19992b39744f4015f252"
  end

  depends_on "cmake" => :build
  depends_on "hdf5"

  def install
    ENV.deparallelize

    system "cmake", ".", "-DUSE_HDF5=ON", *std_cmake_args
    system "make"
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
