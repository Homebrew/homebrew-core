class Cuttlefish < Formula
  desc "Build compacted de Bruijn graphs from references or reads"
  homepage "https://combine-lab.github.io/cuttlefish/"
  url "https://github.com/COMBINE-lab/cuttlefish/archive/refs/tags/v3.1.0.tar.gz"
  sha256 "10eb5b1d7ec4ba4bcb76a10e0d14bace4a2a624f9d8927647b5b82eabe3320b2"
  license "BSD-3-Clause"
  head "https://github.com/COMBINE-lab/cuttlefish.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "790c1bc93135f66ccffa1a453b8ee7ada035426436e9ae341adfee38b2c7e848"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f25452ab1ab0ce9a1e3627d8f7aac941117e0b8b7d9e13eaab4feac0a33847fe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e3001392dd25e4f8f0d3bd0ae9fdaca1eff6860d6e4713123989201ef1057bea"
    sha256 cellar: :any,                 arm64_linux:       "f4185b7ad89821d165524686cffe30bb797c18097aa4f53fa9fd47a8e454fa14"
    sha256 cellar: :any,                 x86_64_linux:      "00e9331cb63accce73e35a844436a75a36daabad1e7396d69cb5906f22a904ec"
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
