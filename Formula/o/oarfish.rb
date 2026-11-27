class Oarfish < Formula
  desc "Long read RNA-seq quantification"
  homepage "https://github.com/COMBINE-lab/oarfish"
  url "https://static.crates.io/crates/oarfish/oarfish-0.13.0.crate"
  sha256 "9395a23b206f9bd5e6c3eda72208641c58ce76f97f10cc42f4a9554d623e280c"
  license "BSD-3-Clause"
  head "https://github.com/COMBINE-lab/oarfish.git", branch: "main"

  bottle do
    manifest_sha256 "59ace7fcbbfbe1218e9a85a86c7155bd40120fc8c1656ca1734d9af9b8816b2c"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b33adb595d5d6d4f4d8c0c383946ef4a1fca7f63865c254949b1d41a1066d39c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "543199a1bdb47683f17b928b46c826a0fa570ecd762168a5b31b74a2ab47c8b1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b2de7f9d2a4980e58dbc978278bae2e8c922010ce6540c5675eeb740d44a375e"
    sha256 cellar: :any,                 arm64_linux:       "0d997e4b6338c9175f17b7bb402c3bf8e5047c018512dedd34c5625a6d2f6946"
    sha256 cellar: :any,                 x86_64_linux:      "f0628b2696754fe386519d38f5518dfbee8cf128ef824657fcb432643a45d9c0"
  end

  depends_on "rust" => :build

  uses_from_macos "bzip2"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def fetch
    system "cargo", "generate-lockfile" if build.head?
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oarfish --version")

    random = Random.new(1)
    transcripts = (1..3).map do |i|
      sequence = Array.new(1000) { "ACGT"[random.rand(4)] }.join
      ">tx#{i}\n#{sequence}\n"
    end
    (testpath/"test.fasta").write transcripts.join
    system bin/"oarfish", "--reads", "test.fasta", "--annotated", "test.fasta",
                          "--seq-tech", "ont-cdna", "--output", "sample"
    assert_match "tx1\t1000\t1", (testpath/"sample.quant").read
  end
end
