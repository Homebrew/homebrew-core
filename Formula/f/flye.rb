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
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "da001a71cb1768fa863629df14bbeac7757f83f19cee3efffbf3e45fe84ac972"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fe6f8b6e489495ed8d374ecdd3918e60eeb5abf1818287817526c6e78b435f78"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "72ae20f3a7b3adc25bc6d27ceaa30c4f03ae07e81723ab4aadd1a9380669684e"
    sha256 cellar: :any_skip_relocation, sonoma:        "e5769476e56abbcb2450acf418837e5bb80005f7be5dd8922db99acb21b2d77b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ec4658bd46026fa973059b18e83ce0ccda8f183afe9ce6050c9f23fd4c3c0f8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "926fdce4a0f64674434d766708ced9310e058ce8ba8f55f7ec2ff2e772b455b1"
  end

  depends_on "python@3.14"
  depends_on "samtools"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    # Replace bundled samtools
    rm_r(Dir["lib/samtools*"])
    (buildpath/"bin").write_exec_script Formula["samtools"].opt_bin/"samtools"
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
