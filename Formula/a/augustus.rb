class Augustus < Formula
  desc "Predict genes in eukaryotic genomic sequences"
  homepage "https://bioinf.uni-greifswald.de/augustus/"
  url "https://github.com/Gaius-Augustus/Augustus/archive/refs/tags/v3.5.0.tar.gz"
  sha256 "5ed6ce6106303b800c5e91d37a250baff43b20824657b853ae04d11ad8bdd686"
  license "Artistic-1.0"
  revision 7
  head "https://github.com/Gaius-Augustus/Augustus.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "d6f2416fdb1f857ab1627378d3263c432af0a3837087e7e1302cbd6eadc1a4d5"
    sha256 cellar: :any,                 arm64_sonoma:   "350db797ec6d550192c11a390b781669758ed582191ced02ade110d07afe36f2"
    sha256 cellar: :any,                 arm64_ventura:  "90566951647f04c9b72aa710b6d2881a4a97f4bb62094d5dfde352e592ae62c9"
    sha256 cellar: :any,                 arm64_monterey: "1f1b4e4579694af0957874030fc20e2e50ceb1c7799a764334ef61d58e487c4a"
    sha256 cellar: :any,                 sonoma:         "2090aaab7aab23a7e8d2b18f09ca6a0b12176b7ce1478e7daa7e2af78491efde"
    sha256 cellar: :any,                 ventura:        "b5fefdb43565bd78a19034dcbb36805584f985d093bcbd124e84cb57230b6b94"
    sha256 cellar: :any,                 monterey:       "7ab71f2bdceb617605d553b0ff19ae03e7b872e3583894939f37e680a63eb248"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a3d31169c172e25b1e6c1d0d0e577475de83af3af063d925d781dc5d6a6021b7"
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
