class Augustus < Formula
  desc "Predict genes in eukaryotic genomic sequences"
  homepage "https://bioinf.uni-greifswald.de/augustus/"
  url "https://github.com/Gaius-Augustus/Augustus/archive/refs/tags/v3.5.0.tar.gz"
  sha256 "5ed6ce6106303b800c5e91d37a250baff43b20824657b853ae04d11ad8bdd686"
  license "Artistic-1.0"
  revision 5
  head "https://github.com/Gaius-Augustus/Augustus.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a5807cda277198b3daa4813b569baa389d5ec28848fef38a756b177cf65331f8"
    sha256 cellar: :any,                 arm64_ventura:  "c652b9b4ebc01fc2405244ee6217d5f4cb5dc9117c912dbb07b8d4fc99e5103c"
    sha256 cellar: :any,                 arm64_monterey: "84345b09f1964e99c7a042aa955820bdacc2f722e9199105b4d7398f3f7122fb"
    sha256 cellar: :any,                 sonoma:         "de43bba765a0b353d01d351de57beb8144f18d14c48e602b18b499aabe13328e"
    sha256 cellar: :any,                 ventura:        "d837f2be6824960befe277b5244b95fe7a1afa8030578ec243d57a083174c584"
    sha256 cellar: :any,                 monterey:       "37f8e61cb684def872944ddb192b069681e1f3a835dd5fdd9442e6c2d66da511"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8699b1669a24f6eed11412b0b5f965ff1f0e1a6b57d5a95b43f1d67f44626e7e"
  end

  depends_on "bamtools"
  depends_on "boost"
  depends_on "htslib"

  uses_from_macos "python" => :build, since: :catalina
  uses_from_macos "zlib"

  def install
    # Compile executables for macOS. Tarball ships with executables for Linux.
    system "make", "clean"

    ENV.append "CXXFLAGS", "-std=c++14"

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
