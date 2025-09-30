class Augustus < Formula
  desc "Predict genes in eukaryotic genomic sequences"
  homepage "https://bioinf.uni-greifswald.de/augustus/"
  url "https://github.com/Gaius-Augustus/Augustus/archive/refs/tags/v3.5.0.tar.gz"
  sha256 "5ed6ce6106303b800c5e91d37a250baff43b20824657b853ae04d11ad8bdd686"
  license "Artistic-1.0"
  revision 11
  head "https://github.com/Gaius-Augustus/Augustus.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "41678b162c8b7a007c3cb62cbe8602a936809ff80dfa32eecf32e3d2f4c14dea"
    sha256 cellar: :any,                 arm64_sequoia: "06f498925823cbdedaf60204cf457f802100a392fa33e528c3b6d1997a01d5d8"
    sha256 cellar: :any,                 arm64_sonoma:  "400c79fab02d6b771cd3f56b416cedf97a478067275cefba4b6c00862702a68a"
    sha256 cellar: :any,                 arm64_ventura: "d0a38630e0aca7c3b35d567e92b5cb88cb21866f0e7a09301eaeeb214e83dc8c"
    sha256 cellar: :any,                 sonoma:        "890855e13b04f2e5344f40e3cafa211b734a115bb1a9e20c7bf990c4c3aa5e42"
    sha256 cellar: :any,                 ventura:       "459888204f0f0a84e2d52ab6d9fe7e432803a9727b8ad83819862ff47c482fef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cf1ce53da5b7c605ef7ccf68be9b7f1445fb952523c9dd26e28dbf69877c1d7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "80b5d3640841e47c9ae79dc92b1521931d9e9c4b74525b16fb985e4d5cf5650d"
  end

  depends_on "bamtools"
  depends_on "boost"
  depends_on "htslib"

  uses_from_macos "python" => :build
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
