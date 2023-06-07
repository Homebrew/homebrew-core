class Augustus < Formula
  desc "Predict genes in eukaryotic genomic sequences"
  homepage "https://bioinf.uni-greifswald.de/augustus/"
  url "https://github.com/Gaius-Augustus/Augustus/archive/refs/tags/v3.5.0.tar.gz"
  sha256 "5ed6ce6106303b800c5e91d37a250baff43b20824657b853ae04d11ad8bdd686"
  license "Artistic-1.0"
  revision 2
  head "https://github.com/Gaius-Augustus/Augustus.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c8a40d5edb2642c2df7d5e93db9305fc0404ba6525ce224db40ea6bafe3ed5d7"
    sha256 cellar: :any,                 arm64_monterey: "07ff9bfa13f2f557ddefe6b1888b3034e8bec8e7285cdc6f04dabe430dbb5c33"
    sha256 cellar: :any,                 arm64_big_sur:  "c092fa44baaa1dde2158195dbd7614339af1f8963bcefd288cf716d36a99fd55"
    sha256 cellar: :any,                 ventura:        "1b560cc1a8133bb39ae900d5240fb9ca740a2c6a8a113024a3ddf87b54212a3b"
    sha256 cellar: :any,                 monterey:       "90d53a60c52ca92a27b8c8bef3084578e6b221817cd64d69de1a0704bcb3e848"
    sha256 cellar: :any,                 big_sur:        "fc23a4198593359283bf2ae522d9cf6e750690c167e483a91eb441a988773e43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f7618e6d6dee6fb77f0f71bc59ef3ada03bbae0fc4aab7cb25f15c1c0c84b348"
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
