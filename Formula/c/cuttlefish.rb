class Cuttlefish < Formula
  desc "Build compacted de Bruijn graphs from references or reads"
  homepage "https://combine-lab.github.io/cuttlefish/"
  url "https://github.com/COMBINE-lab/cuttlefish/archive/refs/tags/v3.0.1.tar.gz"
  sha256 "4ff54df7ebd105196f890b3aa96f97980e77044220b18e668901c7bd21f2d125"
  license "BSD-3-Clause"
  head "https://github.com/COMBINE-lab/cuttlefish.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "df4899064b27a35b0f824bef4eccbfd19fd5e36eced98804187de89c00423d5a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6d9ba948e34307a6ce855708a032e7a6ac59f2c70a90550793b8cb5b34989250"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "260b7796a06102f8166512ec28202d9cc27d1a124ff230f2530c69575d20b2f3"
    sha256 cellar: :any_skip_relocation, sonoma:        "7e98ec0fbb00a4276c348f4c13903bdb59eeddf89c9ef0563fef68bf5af63ec7"
    sha256 cellar: :any,                 arm64_linux:   "a6346d38256d5c5ffb77dcd300a9c9e4286c95fdfdc4cf5db959a278e819bce6"
    sha256 cellar: :any,                 x86_64_linux:  "d9403807ea9a5f15fcee046ef1755ef321c9d8df898e8dc8f8e07ef90cc19ce5"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cuttlefish-rs-cli")
  end

  test do
    seq = "ACGTTGCAATCGGATCCTAGGCATTACGGTTACCGATTCAGGCTAAGTCCATGGCATCAGT"

    (testpath/"ref.fa").write <<~FASTA
      >test
      #{seq}
    FASTA

    system bin/"cuttlefish", "build", "--ref", "--seq", "ref.fa",
           "-k", "31", "-t", "1", "-w", testpath/"work", "-o", testpath/"graph"

    unitigs = (testpath/"graph.fa").read.lines.grep_v(/^>/).map(&:chomp)
    assert_equal 1, unitigs.length
    assert_equal seq.length, unitigs.first.length

    assert_match version.to_s, shell_output("#{bin}/cuttlefish version")
  end
end
