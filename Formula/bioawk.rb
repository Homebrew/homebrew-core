class Bioawk < Formula
  desc "AWK modified for biological data"
  homepage "https://github.com/lh3/bioawk"
  url "https://github.com/lh3/bioawk/archive/v1.0.tar.gz"
  sha256 "5cbef3f39b085daba45510ff450afcf943cfdfdd483a546c8a509d3075ff51b5"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a568547e0fb85d1d0678d157c93aee71710f58d3bc4591186365ae28e4502b24"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "de4d41adcf20cf87de3d2310d98c1dbfbff95eb3432e6d0888be964889f024c6"
    sha256 cellar: :any_skip_relocation, monterey:       "844d8041e128ebcf46d1a5dec20dfc22f0a3fc1ff48388310cf810685acd9890"
    sha256 cellar: :any_skip_relocation, big_sur:        "f0e6d3b143b32066da8f41266d1edf2855ab0d780982c8eb09b78194c1e2484e"
    sha256 cellar: :any_skip_relocation, catalina:       "c7377ef6e226404f71d52c04715ea0bb8456e1c90493e93e78101dfb3ed2190e"
    sha256 cellar: :any_skip_relocation, mojave:         "7082d4073e07ba3dfa849f95eb126d966a45f9fceb1d197595119a216e465727"
    sha256 cellar: :any_skip_relocation, high_sierra:    "023f5cafaa31404e68b8fc6bcfbeee27e63eb5fbcab897d2f406fceda90ec9ff"
    sha256 cellar: :any_skip_relocation, sierra:         "154d44dd9ea56db8170127711e991950d487e379ae12df76332e4b7512f79fe8"
    sha256 cellar: :any_skip_relocation, el_capitan:     "df0810bc087f924cdddcdb73f00faf9772de9475e0e698c7af8a7d036b3a4c91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1d611e2578e57304e571f02a58ec46efc83752a97a7d830b40e03a2c83749bb3"
  end

  uses_from_macos "bison" => :build
  uses_from_macos "zlib"

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
