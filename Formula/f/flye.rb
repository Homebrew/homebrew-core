class Flye < Formula
  include Language::Python::Virtualenv

  desc "De novo assembler for single molecule sequencing reads using repeat graphs"
  homepage "https://github.com/mikolmogorov/Flye"
  url "https://github.com/mikolmogorov/Flye/archive/refs/tags/2.9.7.tar.gz"
  sha256 "041635b3b7e7afc69fd50ab9cbf040db4749b04ae626ba65c8b08f550642351f"
  license all_of: [
    "BSD-3-Clause",
    "Apache-2.0", # lib/libcuckoo
    "BSL-1.0",    # lib/lemon
    "CC-BY-3.0",  # src/common/memory_info.h
    "MIT",        # lib/{interval_tree,minimap2}
  ]
  head "https://github.com/mikolmogorov/Flye.git", branch: "flye"

  bottle do
    manifest_sha256 "92816e4b6b873706c138e3060b2628cd976feb6b4a1253367bf338cf0b811315"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "eeba63bee15ff606b5b3bc0bed01bc5014ad88f736d00bb9916879104f088bf4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2c7bbc96f7d7bca0faa9664d04484a334a18482e285d9751a6ecdacd4bba2c44"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e3a99a0f664ffdc99a802b3c1d60b17776cec72f22d54672044a143ed372bb7f"
    sha256 cellar: :any,                 arm64_linux:       "967a146dd6be450d82784387bd647efadef7e5aec454c401a98515b6235be012"
    sha256 cellar: :any,                 x86_64_linux:      "d9490261e843a5100bc160bbbf43de9e2fc3865ec57d5b0e725edc005f8f593b"
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
