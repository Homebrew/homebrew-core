class Flye < Formula
  include Language::Python::Virtualenv

  desc "De novo assembler for single molecule sequencing reads using repeat graphs"
  homepage "https://github.com/mikolmogorov/Flye"
  url "https://github.com/mikolmogorov/Flye/archive/refs/tags/2.9.6.tar.gz"
  sha256 "f05a3889b1c7aafed4cc0ed1adc1f19c22618c1c7b97ab5f80d388c8192bd32a"
  license all_of: [
    "BSD-3-Clause",
    "Apache-2.0", # lib/libcuckoo
    "BSL-1.0",    # lib/lemon
    "CC-BY-3.0",  # src/common/memory_info.h
    "MIT",        # lib/{interval_tree,minimap2}
  ]
  head "https://github.com/mikolmogorov/Flye.git", branch: "flye"

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5b33ea78b7d3239be461b15546746298fa97c61fd55154a44fb42452280a8987"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8cf39112533b510aba6d872c17d1d4488476c44e81e5455b687511c576717c21"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "62707abbb4e2af929c602c9c14feff1bfe4bff0a698e8777064f747fc9858581"
    sha256 cellar: :any,                 arm64_linux:       "c076fce9b0285052cad327094ee3112c83f104923d968c06f17515db69488a90"
    sha256 cellar: :any,                 x86_64_linux:      "64311add2fe8e416832d99a9037929124da14e7fcebf6537cbddbd501b0d6fdc"
  end

  depends_on "python@3.15"
  depends_on "samtools"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    # Replace bundled samtools
    rm_r(Dir["lib/samtools*"])
    (buildpath/"bin").write_exec_script formula_opt_bin("samtools")/"samtools"
    (buildpath/"bin").install "bin/samtools" => "flye-samtools"
    chmod 0755, "bin/flye-samtools"

    # Workaround for arm64 Linux: https://github.com/mikolmogorov/Flye/pull/691
    ENV["arm_neon"] = ENV["aarch64"] = "1" if OS.linux? && Hardware::CPU.arm64?

    ENV.deparallelize
    venv = virtualenv_install_with_resources
    pkgshare.install_symlink venv.site_packages/"flye/tests/data"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/flye --version")
    system bin/"flye", "--pacbio-corr", pkgshare/"data/ecoli_500kb_reads_hifi.fastq.gz", "-o", testpath
    assert_path_exists "assembly.fasta"
  end
end
