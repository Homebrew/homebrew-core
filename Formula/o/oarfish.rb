class Oarfish < Formula
  desc "Long read RNA-seq quantification"
  homepage "https://github.com/COMBINE-lab/oarfish"
  url "https://github.com/COMBINE-lab/oarfish/archive/refs/tags/v0.10.3.tar.gz"
  sha256 "4fb1d8122ec9e052ca91f127feb374b9feb01b50e202590f7fe3f38b37070aff"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c792c4bae408049d6e66c63331fb75cdca917723e775587e7c7d4d2d825e9ca4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "30534b817fab64999aba644e6cbf24c9aef18b9e992c905f7cb6e9c2d315d21b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7b08eff1a22c04960b425c76f621e456c07992798f295dfcd7ebb1222ad5add2"
    sha256 cellar: :any_skip_relocation, sonoma:        "07ab371791d2f6aff94d72ca6debef99908c846084bd34f936718df87b08e226"
    sha256 cellar: :any,                 arm64_linux:   "1c827870e17fc949fb2e704ad964fddd1d9a414b6a52ad4afab2cac8be932da4"
    sha256 cellar: :any,                 x86_64_linux:  "ea53a4f93e5811b51a133bd8a18bd14cacccb425ec6e604b4dc10802b6189d77"
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
