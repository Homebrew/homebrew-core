class Oarfish < Formula
  desc "Long read RNA-seq quantification"
  homepage "https://github.com/COMBINE-lab/oarfish"
  url "https://github.com/COMBINE-lab/oarfish/archive/refs/tags/v0.9.4.tar.gz"
  sha256 "d991443d224edd97d6951b5d99c17bc1c920dc137fb0c606bc3dc5b9f3d25b62"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "12b890e8f49a81c2187ada86430d011e2c82dce7845fed0b1939f1a47c2a3b06"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f6a2879736b570eb10a1573db41b94b5dc89971d26b129e70500fac42588e950"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "14fe4b957e0505a07d7226cf75fd3926d2f0da368be0ba2ebce28c2c6bcff1db"
    sha256 cellar: :any_skip_relocation, sonoma:        "5853e72f7739fce7c0db125d2ad1c0753e59bf3a06ee50e8587b954cc0d39245"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "87b8dca3f609adb67d5a50bce43ca50e3fd5431c1b0b23a5333e36aab77c94b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c39a1ef9df8e29ecd014dca0df060ba3c196dcf82b6f525aa051284e8f661338"
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
