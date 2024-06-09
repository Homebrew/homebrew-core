class Kallisto < Formula
  desc "Quantify abundances of transcripts from RNA-Seq data"
  homepage "https://pachterlab.github.io/kallisto/"
  url "https://github.com/pachterlab/kallisto/archive/refs/tags/v0.50.1.tar.gz"
  sha256 "030752bab3b0e33cd3f23f6d8feddd74194e5513532ffbf23519e84db2a86d34"
  license "BSD-2-Clause"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b72e208558837c34d5d568870efd392d4ace50736201577926f1c470231cb51f"
    sha256 cellar: :any,                 arm64_ventura:  "881cc4e56078e9b8bfa5d40d8870d595041ec8ec330332b18e55894626902394"
    sha256 cellar: :any,                 arm64_monterey: "32356e5bfc9de68eea6b181ae391f3c4730462882ac6cb397d8205c54654f207"
    sha256 cellar: :any,                 sonoma:         "47e3b307b8fea2c470d523bf3406c2d34573a63c6cb0fd68008f0a57c2940640"
    sha256 cellar: :any,                 ventura:        "8b91fa3d58a117c213fd5040ea3d500cae0f467279be9428f36374be6653b997"
    sha256 cellar: :any,                 monterey:       "352acfa20a7bce0e87bddfb385cca39fc6979342866d48a13306338e6941e272"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a837f4beaf83ee36cffdebdcc833da829f5ca973555c9258c6b8c45b08a9744e"
  end

  depends_on "cmake" => :build
  depends_on "hdf5"

  def install
    ENV["SDKROOT"] = MacOS.sdk_path if OS.mac?
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
