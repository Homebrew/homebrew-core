class Augustus < Formula
  desc "Predict genes in eukaryotic genomic sequences"
  homepage "https://bioinf.uni-greifswald.de/augustus/"
  url "https://github.com/Gaius-Augustus/Augustus/archive/refs/tags/v3.5.0.tar.gz"
  sha256 "5ed6ce6106303b800c5e91d37a250baff43b20824657b853ae04d11ad8bdd686"
  license "Artistic-1.0"
  revision 13
  head "https://github.com/Gaius-Augustus/Augustus.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "e0a564d394d12f7613b2e36fcb67387f22a9f3148902d642e868b8be0c63d823"
    sha256 cellar: :any, arm64_sequoia: "c21d3fb3e27b894318067d2b7fee41b7d51e46bec958378724c4811f0cea0644"
    sha256 cellar: :any, arm64_sonoma:  "543cb2e56b69faa1aa12e9872aac4fc42954bfb48e174c3e8356dcdf1fe4f039"
    sha256 cellar: :any, sonoma:        "bdb7161519aeaf9cef5d56202be49c679c50bd75b6c6b5ba5f7c82b0af3c12ad"
    sha256 cellar: :any, arm64_linux:   "d49e214bbfef0007ac5f8b392eb223b2070bd3a9f0fb5cdb7287a5f2dcb27526"
    sha256 cellar: :any, x86_64_linux:  "df1e594b2893b4be491105152976449a40626ac5640fd4134ba7f29c66fbd941"
  end

  depends_on "bamtools"
  depends_on "boost"
  depends_on "htslib"

  uses_from_macos "python" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    # Compile executables for macOS. Tarball ships with executables for Linux.
    system "make", "clean"

    ENV.append "CXXFLAGS", "-std=c++14"

    system "make", "COMPGENEPRED=false",
                   "INCLUDE_PATH_BAMTOOLS=-I#{formula_opt_include("bamtools")}/bamtools",
                   "LIBRARY_PATH_BAMTOOLS=-L#{formula_opt_lib("bamtools")}",
                   "INCLUDE_PATH_HTSLIB=-I#{formula_opt_include("htslib")}/htslib",
                   "LIBRARY_PATH_HTSLIB=-L#{formula_opt_lib("htslib")}"

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
