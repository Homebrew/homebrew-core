class Hifiasm < Formula
  desc "Haplotype-resolved de novo assembler for PacBio HiFi reads"
  homepage "https://github.com/chhylp123/hifiasm"
  url "https://github.com/chhylp123/hifiasm/archive/refs/tags/0.25.0.tar.gz"
  sha256 "51633138865207a9d41630da9377d46e4921ad4fc5facaa1740ceccae8611f1f"
  license "MIT"
  head "https://github.com/chhylp123/hifiasm.git", branch: "master"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  on_arm do
    depends_on "sse2neon" => :build
  end

  def install
    args = ["CC=#{ENV.cc}", "CXX=#{ENV.cxx}"]

    if Hardware::CPU.arm?
      # Redirect the x86 intrinsics headers to sse2neon
      shim = buildpath/"sse2neon-shim"
      %w[emmintrin immintrin nmmintrin smmintrin].each do |header|
        (shim/"#{header}.h").write "#include <sse2neon.h>\n"
      end
      args << "CXXFLAGS=-O3 -fomit-frame-pointer -Wall -I#{shim} -I#{formula_opt_include("sse2neon")}"
    end

    system "make", *args
    bin.install "hifiasm"
    man1.install "hifiasm.1"
  end

  test do
    random = Random.new(42)
    genome = Array.new(20_000) { "ACGT"[random.rand(4)] }.join
    reads = Array.new(120) do |i|
      start = random.rand(genome.length - 5_000)
      read = genome[start, 5_000]
      read = read.reverse.tr("ACGT", "TGCA") if i.odd?
      "@read#{i}\n#{read}\n+\n#{"I" * read.length}\n"
    end
    (testpath/"reads.fq").write reads.join

    system bin/"hifiasm", "-o", "asm", "-t", "2", "-f0", "-l0", "reads.fq"
    contigs = (testpath/"asm.bp.p_ctg.gfa").read.lines.grep(/^S\t/)
    assert_equal 1, contigs.length
    assert_operator contigs.first.split("\t")[2].length, :>, 19_000
  end
end
