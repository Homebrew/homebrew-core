class Cuttlefish < Formula
  desc "Build compacted de Bruijn graphs from references or reads"
  homepage "https://combine-lab.github.io/cuttlefish/"
  url "https://github.com/COMBINE-lab/cuttlefish/archive/refs/tags/v3.0.2.tar.gz"
  sha256 "41551ba8da867e3edcbfd95dbf044701add080fdb64393058e8d17714689145d"
  license "BSD-3-Clause"
  head "https://github.com/COMBINE-lab/cuttlefish.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3b3710837da27d157a57fe25d540191d95accdb95d79c44e709860f778702fbf"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a2c9665269223cf816c3a5afa1446d75bcc3ba2aef9d3bf3b835cd7ca9ea85a5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f2c8bea00ff0432b816d3a82bf3aa7e3b9d1d6337be00bbab1b306f9330905cd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "2d8575e85701e7af6ca8335ce83afe352239f75f173ced78dcdd255bdcc2e7c4"
    sha256 cellar: :any,                 arm64_linux:       "90e3a258249d180671e8c0321ec9f0e413d1ae96de2833aa2a009f79027776fe"
    sha256 cellar: :any,                 x86_64_linux:      "9d8f7085756b4af44d36d5b081b3748af6f026c9bb156a27d5aab130f1fa3ada"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", "--locked"
  end

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
