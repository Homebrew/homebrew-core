class Augustus < Formula
  desc "Predict genes in eukaryotic genomic sequences"
  homepage "https://bioinf.uni-greifswald.de/augustus/"
  url "https://github.com/Gaius-Augustus/Augustus/archive/refs/tags/v3.5.0.tar.gz"
  sha256 "5ed6ce6106303b800c5e91d37a250baff43b20824657b853ae04d11ad8bdd686"
  license "Artistic-1.0"
  revision 10
  head "https://github.com/Gaius-Augustus/Augustus.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f47cdb45ef4200baba259b2121c4ff8a891718d1fdb05d2dde50bf05cff4c6e9"
    sha256 cellar: :any,                 arm64_sonoma:  "f1aebc2cc4d9edea554a9d6c8d97fe7a9cc1c5472f4fce02a52ef24bdafb39b3"
    sha256 cellar: :any,                 arm64_ventura: "c1ca454de2e8c22ba3bf665bbeaaaf817bcfeab300cc0bb4c554304d7438e80c"
    sha256 cellar: :any,                 sonoma:        "a90a9c0bc0d71ea9e05ac892b70674c96761a58cd7de65d9c1faf88da530019b"
    sha256 cellar: :any,                 ventura:       "66bb31467b3216cf1f87dd1dde80d276a32efc9e66b20e1bc7c06874fc3b77c3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b8ba8fa93a2f0295ca879dc553cf209e47f831519aad7d7aa45a7423eb77d8cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ac23536a2d77a19a651f49b26ff56382cbc3c9b535b1ce015831375165548dfa"
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
