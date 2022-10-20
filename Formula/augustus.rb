class Augustus < Formula
  desc "Predict genes in eukaryotic genomic sequences"
  homepage "https://bioinf.uni-greifswald.de/augustus/"
  url "https://github.com/Gaius-Augustus/Augustus/archive/refs/tags/v3.5.0.tar.gz"
  sha256 "5ed6ce6106303b800c5e91d37a250baff43b20824657b853ae04d11ad8bdd686"
  license "Artistic-1.0"
  revision 1
  head "https://github.com/Gaius-Augustus/Augustus.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "bb001f41a131cf3065eca32fe225afa567728d35b163f98dfd71a57b2aaf2a3d"
    sha256 cellar: :any,                 arm64_big_sur:  "ce56e04aa4c4f706485616f2a7947ae59538391ec58100e20cbf5216bd3311a9"
    sha256 cellar: :any,                 monterey:       "ae8d067cd836352d3aea30d22563eba8167fbc8223e24edfab93af36f623f63d"
    sha256 cellar: :any,                 big_sur:        "955b4dc7f98c97aef46a05c8c1075054186bffa7b79bc49305ae8086f494ec02"
    sha256 cellar: :any,                 catalina:       "0c01281063e3b4a3de714959e04e30229713e6043ea12fb050e546f7f69f62a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b9850f064f781034382d8f821bfffbb2d11492ead09af7f55ebe74a8756ccf8c"
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
