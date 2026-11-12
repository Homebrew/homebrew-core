class Oarfish < Formula
  desc "Long read RNA-seq quantification"
  homepage "https://github.com/COMBINE-lab/oarfish"
  url "https://github.com/COMBINE-lab/oarfish/releases/download/v0.12.0/source.tar.gz"
  sha256 "037f6aabf4943078b9703daf7978f5eb5805e1ada266cdfc378d4edbdb4562d3"
  license "BSD-3-Clause"
  head "https://github.com/COMBINE-lab/oarfish.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ed7bb78ff8d62d1b299fe7a2b619efc0fb623519ddff04a9945430bcfc7d1327"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b34b87f738a59f8c7fd4b627a49505f6171eb7ecbaeac3a548a1c11563dcca9f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ffeee4913525b0372d0d0020c79062a460d18e39bf9f33522ed708edfe1878b5"
    sha256 cellar: :any,                 arm64_linux:       "7d9ead59ed95bfbeaee0d6a867cd27bbc71626b7523bddea08fdc4234f754ff1"
    sha256 cellar: :any,                 x86_64_linux:      "0257bc5648f56c66505ce4cc8a9bec93ffade250679fa80664dbc16f8033c9ba"
  end

  depends_on "rust" => :build

  uses_from_macos "bzip2"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def fetch
    # `Cargo.lock` is ignored
    system "cargo", "generate-lockfile"
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
    pkgshare.install "test_data"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oarfish --version")

    cp_r pkgshare/"test_data/SIRV_isoforms_multi-fasta_170612a.fasta", testpath/"test.fasta"
    system bin/"oarfish", "--reads", "test.fasta", "--annotated", "test.fasta",
                          "--seq-tech", "ont-cdna", "--output", "sample"
    assert_path_exists "sample.quant"
  end
end
