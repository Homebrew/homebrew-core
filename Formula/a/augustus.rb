class Augustus < Formula
  desc "Predict genes in eukaryotic genomic sequences"
  homepage "https://bioinf.uni-greifswald.de/augustus/"
  url "https://github.com/Gaius-Augustus/Augustus/archive/refs/tags/v3.6.0.tar.gz"
  sha256 "d1c50bb2b2f79c86c1dfa4ef52a5a082d9f4f24cf28f9a3e181207e80eac8757"
  license "Artistic-1.0"
  head "https://github.com/Gaius-Augustus/Augustus.git", branch: "master"

  bottle do
    manifest_sha256 "abe89ddead9af77865732df9fbef1fdf74d12ec532bd8367bd8eb795e9e67dc4"
    sha256 cellar: :any, arm64_golden_gate: "2dd181a79f6f0af2b0836755afb5a79c954c6938fa1535af1cc0250afa73433f"
    sha256 cellar: :any, arm64_tahoe:       "75324760db2d914e46f9654049058c52358f9aeeefae8267c6e13e3d306cf217"
    sha256 cellar: :any, arm64_sequoia:     "5465884bcde83930007dbdb4f3d45e09b8263565c63038203c18f3e5bca333ab"
    sha256 cellar: :any, arm64_linux:       "f0ac15b24639df0e511780eed8cd6db5e4c47d52de5ff45d62e53096045cc29d"
    sha256 cellar: :any, x86_64_linux:      "161db464540e4b59aab078eee715d35fbbd6917b1c5e556e5786ef1c979b8c05"
  end

  depends_on "bamtools"
  depends_on "boost"
  depends_on "htslib"

  uses_from_macos "python" => :build

  deny_network_access!

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
    system "make", "install", "INSTALLDIR=#{prefix}", "prefix=#{buildpath}/tmp"

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
