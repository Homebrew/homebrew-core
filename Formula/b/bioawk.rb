class Bioawk < Formula
  desc "AWK modified for biological data"
  homepage "https://github.com/lh3/bioawk"
  url "https://github.com/lh3/bioawk/archive/refs/tags/v1.0.tar.gz"
  sha256 "5cbef3f39b085daba45510ff450afcf943cfdfdd483a546c8a509d3075ff51b5"
  license "HPND"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dc8c77af3f46588cab03f40541d48dfa09fe06115be3be5c42495213ad7fa003"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f4f29845cf2a16730b9ade42596e972a8ac74b0eee296bed5bede33a08903ae0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "843653fc5797fdf0a2ba5203dab1f73261a05f2f43e6fff2ba123726cb85aa7d"
    sha256 cellar: :any_skip_relocation, sonoma:        "6eb824cbf1be1f383777e3cfc835929ccf9e872aff310edad8cd279a0e503550"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cf7bf412ddbdf9a37d1e63c4227290886366f91d3a97b1a574c2577a93a99380"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e0a03da1e2774fcef306bcf11edac499e446d2fc9bd413078ce56f38ed1ad52"
  end

  uses_from_macos "bison" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    # Fix make: *** No rule to make target `ytab.h', needed by `b.o'.
    ENV.deparallelize

    system "make"
    bin.install "bioawk"
    man1.install "awk.1" => "bioawk.1"
  end

  test do
    (testpath/"test.fasta").write <<~EOS
      >U00096.2:1-70
      AGCTTTTCATTCTGACTGCAACGGGCAATATGTCT
      CTGTGTGGATTAAAAAAAGAGTGTCTGATAGCAGC
    EOS
    cmd = "#{bin}/bioawk -cfastx '{print length($seq)}' test.fasta"
    assert_equal "70", shell_output(cmd).chomp
  end
end
