class Oarfish < Formula
  desc "Long read RNA-seq quantification"
  homepage "https://github.com/COMBINE-lab/oarfish"
  url "https://github.com/COMBINE-lab/oarfish/releases/download/v0.10.3/source.tar.gz"
  sha256 "de886868c4efb9ef7a77d0865bb4bda7effcf7143841c2a74e3ec714e49e4546"
  license "BSD-3-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a825a935ca973abd17f8e08e48e6242e082e3826f16fbfe37e9caa47c6a493a2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "229428851da26cdccbfd1488e0c4c9a45f0fe57f992e55cd381a7a1aa912b0f8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b688611731642b1dba31f289c043ac84210d254026fabfef1e326d58b2c11af8"
    sha256 cellar: :any_skip_relocation, sonoma:        "004c3e9a45e1befd52a323082cd33ce6e831a6054f48faf822237da24da33e0f"
    sha256 cellar: :any,                 arm64_linux:   "466b3bcb324dfecc76f8c4df9c960393987db651c37715a4ce995279bb410029"
    sha256 cellar: :any,                 x86_64_linux:  "ecde4773d83ccabf13c697747f443f504f949e1b458b2909a0eed0879e3919e0"
  end

  depends_on "rust" => :build

  uses_from_macos "bzip2"

  on_linux do
    depends_on "zlib-ng-compat"
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
