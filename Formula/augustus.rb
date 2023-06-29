class Augustus < Formula
  desc "Predict genes in eukaryotic genomic sequences"
  homepage "https://bioinf.uni-greifswald.de/augustus/"
  url "https://github.com/Gaius-Augustus/Augustus/archive/refs/tags/v3.5.0.tar.gz"
  sha256 "5ed6ce6106303b800c5e91d37a250baff43b20824657b853ae04d11ad8bdd686"
  license "Artistic-1.0"
  revision 3
  head "https://github.com/Gaius-Augustus/Augustus.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8c9aee5e4124894239408be9ce726e328aba6b9404fc65b285f6b177a4bb513e"
    sha256 cellar: :any,                 arm64_monterey: "0ad183caab97870c9208a4340b684994c16d27cb32273f594ee99c2344ad0771"
    sha256 cellar: :any,                 arm64_big_sur:  "429db38ca5d24188747ccdcc5845b2ba42f2f9ac04a676d9dc55cea5d4961e63"
    sha256 cellar: :any,                 ventura:        "8e3e5e7e74a3b67fc12e5b850dfc896dcac4536eee9661f717e6536b2bd35761"
    sha256 cellar: :any,                 monterey:       "310d5947d823b3a81ef01c1666d32d15d77ac426d13f0820ee3040457776f012"
    sha256 cellar: :any,                 big_sur:        "2ed0f1945427ef02649dcc4cd54391a9c69d243911e99c02b7f34dabc7fc3020"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae7c05bcaaf372c82b2638b7eb4d8abbc217af98f0831577f50f5780ae8be2ae"
  end

  depends_on "bamtools"
  depends_on "boost"
  depends_on "htslib"

  uses_from_macos "python" => :build, since: :catalina
  uses_from_macos "zlib"

  def install
    # Compile executables for macOS. Tarball ships with executables for Linux.
    system "make", "clean"

    system "make", "COMPGENEPRED=false",
                   "INCLUDE_PATH_BAMTOOLS=-I#{Formula["bamtools"].opt_include}/bamtools",
                   "LIBRARY_PATH_BAMTOOLS=-L#{Formula["bamtools"].opt_lib}",
                   "INCLUDE_PATH_HTSLIB=-I#{Formula["htslib"].opt_include}/htslib",
                   "LIBRARY_PATH_HTSLIB=-L#{Formula["htslib"].opt_lib}"

    # Set PREFIX to prevent symlinking into /usr/local/bin/
    (buildpath/"tmp/bin").mkpath
    system "make", "install", "INSTALLDIR=#{prefix}", "PREFIX=#{buildpath}/tmp"

    bin.env_script_all_files libexec/"bin", AUGUSTUS_CONFIG_PATH: prefix/"config"
    pkgshare.install "examples"
  end

  test do
    (testpath/"test.fasta").write <<~EOS
      >U00096.2:1-70
      AGCTTTTCATTCTGACTGCAACGGGCAATATGTCTCTGTGTGGATTAAAAAAAGAGTGTCTGATAGCAGC
    EOS
    cmd = "#{bin}/augustus --species=human test.fasta"
    assert_match "Predicted genes", shell_output(cmd)

    cp pkgshare/"examples/example.fa", testpath
    cp pkgshare/"examples/profile/HsDHC.prfl", testpath
    cmd = "#{bin}/augustus --species=human --proteinprofile=HsDHC.prfl example.fa 2> /dev/null"
    assert_match "HS04636	AUGUSTUS	gene	966	6903	1	+	.	g1", shell_output(cmd)
  end
end
