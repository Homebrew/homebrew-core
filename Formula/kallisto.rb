class Kallisto < Formula
  desc "Quantify abundances of transcripts from RNA-Seq data"
  homepage "https://pachterlab.github.io/kallisto/"
  url "https://github.com/pachterlab/kallisto/archive/v0.43.1.tar.gz"
  sha256 "2164938c2c61c04e338c4c132cf749f56d39e6f0b4c517121bca1fbc218e430e"
  revision 1

  bottle do
    cellar :any
    sha256 "7def510bff1b872bff522fc561ccf197d2810f1d8df8fa3bf1870225ec74bd6a" => :high_sierra
    sha256 "975be5f037dfc6a47b65ef79bc3c3a9a0583e7eaa36add776a034a7bdf7f3893" => :sierra
    sha256 "9174135661c12414338e2a5280ee31951f97e8d55bd30ba423099e9b872da42e" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "hdf5"

  def install
    system "cmake", ".", *std_cmake_args
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
