class Oarfish < Formula
  desc "Long read RNA-seq quantification"
  homepage "https://github.com/COMBINE-lab/oarfish"
  url "https://github.com/COMBINE-lab/oarfish/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "f8715c6fc2a23c1041d30303fa1a9d7a6e463ed5cc8e543526c085a64d5abfe9"
  license "BSD-3-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d5ce9664be4d5ae8fcf8e7d4c0b35cedbf3e8da5023b1b1005c50840d47b24f6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3adb87ebc03995dd9df4c731f4b36058ef08fd2b3e7eb51e25680bcb8a782b39"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fde6f151d919ee41b3bdf46fb2a1b610b763d264a9e028446a133a55be6b4dd7"
    sha256 cellar: :any_skip_relocation, sonoma:        "a73f608ab6699602d615e4e70e5d1203548ec53a97876889307ee610944c7094"
    sha256 cellar: :any,                 arm64_linux:   "f8941d5ae8df1e577b50d16f76d60478d3c1860fadae6937a8845d3b0b4ef948"
    sha256 cellar: :any,                 x86_64_linux:  "d18673039270574205c4d5cccb044877c97b9e927c3ac8a3572f2c08b2b966a8"
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
