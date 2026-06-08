class Oarfish < Formula
  desc "Long read RNA-seq quantification"
  homepage "https://github.com/COMBINE-lab/oarfish"
  url "https://github.com/COMBINE-lab/oarfish/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "f8715c6fc2a23c1041d30303fa1a9d7a6e463ed5cc8e543526c085a64d5abfe9"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "97b191385b9c87a080f4114487766148bd881481e9385771c86d48225160bd3e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ab18a2ca9ce121fc380b4b0aa577b3694c6841a8ba5afb5cdbb848e86514c1d6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a0fb702c0ff0a6f5925860f37f6cb8d6ff98aa81d8ce4e16d32b59e9aa09d547"
    sha256 cellar: :any_skip_relocation, sonoma:        "9df4db569d3a4e1ac35af390c4b7f34fdf20ff424637757522657970d5233440"
    sha256 cellar: :any,                 arm64_linux:   "7636627e3e9dfc3e6a6fe5ef86c405fcab5bc0b6bfdab55afcb721ccebc0ede8"
    sha256 cellar: :any,                 x86_64_linux:  "6c12bfb6d937fdd394f97fe00e4aedba33ddf6ee3854870667e29df98cf61f5c"
  end

  depends_on "rust" => :build

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

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
