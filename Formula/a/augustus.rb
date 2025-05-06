class Augustus < Formula
  desc "Predict genes in eukaryotic genomic sequences"
  homepage "https://bioinf.uni-greifswald.de/augustus/"
  url "https://github.com/Gaius-Augustus/Augustus/archive/refs/tags/v3.5.0.tar.gz"
  sha256 "5ed6ce6106303b800c5e91d37a250baff43b20824657b853ae04d11ad8bdd686"
  license "Artistic-1.0"
  revision 9
  head "https://github.com/Gaius-Augustus/Augustus.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2ddf6c680cfc4d37f2f5f7b4b9b5faa71538d97ab71f44b2b97893bb8233cc4e"
    sha256 cellar: :any,                 arm64_sonoma:  "53540ba4b764ca176dcc661c80a1a3e70c4bd5aad113c1cddaa9cc56d99edf41"
    sha256 cellar: :any,                 arm64_ventura: "bb619314f3d0aeacc0e8f6ae9c733ecf3e02b72765113d7ea306567f1df069ba"
    sha256 cellar: :any,                 sonoma:        "81e82f22d4d7e5de19ba30f8491d48e03f9d9a410773d07fdf40afd0252f9bbb"
    sha256 cellar: :any,                 ventura:       "69aa5e235f2462f35c8c4da01acc565e0121ecd0b1c4bbba41943ff5f12f1a23"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "307e210b3938c6979d15dc96851ec826ce66a2f519d2ba397da4a914998cbd3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a272bbb973215e5a8b4167bc31fe5c039664d118514370761b2a92cf7cdd6a2"
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
