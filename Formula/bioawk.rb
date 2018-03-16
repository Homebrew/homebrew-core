class Bioawk < Formula
  desc "AWK modified for biological data"
  homepage "https://github.com/lh3/bioawk"
  url "https://github.com/lh3/bioawk/archive/v1.0.tar.gz"
  sha256 "5cbef3f39b085daba45510ff450afcf943cfdfdd483a546c8a509d3075ff51b5"

  bottle do
    cellar :any_skip_relocation
    sha256 "023f5cafaa31404e68b8fc6bcfbeee27e63eb5fbcab897d2f406fceda90ec9ff" => :high_sierra
    sha256 "154d44dd9ea56db8170127711e991950d487e379ae12df76332e4b7512f79fe8" => :sierra
    sha256 "df0810bc087f924cdddcdb73f00faf9772de9475e0e698c7af8a7d036b3a4c91" => :el_capitan
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
