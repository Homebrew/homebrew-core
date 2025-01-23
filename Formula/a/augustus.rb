class Augustus < Formula
  desc "Predict genes in eukaryotic genomic sequences"
  homepage "https://bioinf.uni-greifswald.de/augustus/"
  url "https://github.com/Gaius-Augustus/Augustus/archive/refs/tags/v3.5.0.tar.gz"
  sha256 "5ed6ce6106303b800c5e91d37a250baff43b20824657b853ae04d11ad8bdd686"
  license "Artistic-1.0"
  revision 8
  head "https://github.com/Gaius-Augustus/Augustus.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4cc459090f1dc6db0b5403e451bad565ffba82a4b922fcc666c14a776fc50a17"
    sha256 cellar: :any,                 arm64_sonoma:  "db3ab9673ae0e90212a7684eaae3a4cef4a652a3c57d3e59705e44d0cd2d946d"
    sha256 cellar: :any,                 arm64_ventura: "a0c7f465a466c6a32433581d54579330ee7baab1747bad2510f22fa37c498e17"
    sha256 cellar: :any,                 sonoma:        "dfb128fd5b03c199862f2d8b90d25a69527b8068727d1b127fa952d520cdbd6d"
    sha256 cellar: :any,                 ventura:       "ad0a9a0a4e5c59580885ad6cdc43dc7068af49aee93b9510a3f73435ad0c8e6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dea2f0b6705a6fb821d6abba6ffc4d40afdc2cd3f0759d53aa12ff3d907006e7"
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
