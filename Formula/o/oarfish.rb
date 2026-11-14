class Oarfish < Formula
  desc "Long read RNA-seq quantification"
  homepage "https://github.com/COMBINE-lab/oarfish"
  url "https://github.com/COMBINE-lab/oarfish/releases/download/v0.13.0/source.tar.gz"
  sha256 "9c418fcf6eb0be13158e52045a0612b4f89f7bad91c6b2659f853f857d4435cb"
  license "BSD-3-Clause"
  head "https://github.com/COMBINE-lab/oarfish.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "51fa51ce2171f22c8f0eaf8427303e5be029b0d6277e4a848e1ae8dd777635bb"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "658c270cb1debfebf92f32a984140c289869943889173b1a4d668e34200663d2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b5eb00275aff717e240fd5b7e70f6fa8dc4fb29e6509865ed921e9af90f93bd6"
    sha256 cellar: :any,                 arm64_linux:       "8685a95b29c787ba14f8edc5670e32fd4f6a5641653cbff6c5b58c514e31a4cf"
    sha256 cellar: :any,                 x86_64_linux:      "36f8fcdeb8f79b1d4d78ff5823352b957520234f68fcb7281cebaeeac54d3b01"
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
