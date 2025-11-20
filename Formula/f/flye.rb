class Flye < Formula
  include Language::Python::Virtualenv

  desc "De novo assembler for single molecule sequencing reads using repeat graphs"
  homepage "https://github.com/mikolmogorov/Flye"
  url "https://github.com/mikolmogorov/Flye/archive/refs/tags/2.9.6.tar.gz"
  sha256 "f05a3889b1c7aafed4cc0ed1adc1f19c22618c1c7b97ab5f80d388c8192bd32a"
  license all_of: ["BSD-3-Clause", "Apache-2.0", "BSD-2-Clause", "BSL-1.0", "MIT"]
  head "https://github.com/mikolmogorov/Flye.git", branch: "flye"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f529f85d3dcabc36f7c906181fc4c8498c994255074dbe968c1122cb7a7d3179"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "96788c42c802e74ea9b06d82eb27e82cd977de0672eaffc42a07542565288bab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "71a2628f455e185cc72891547274dde976a4d99f22abaff4c85ba3837ed1f7e8"
    sha256 cellar: :any_skip_relocation, sonoma:        "488225f78d85e2b0f09fbd105bbec666a105fa50dd5e551447da911c6afbf133"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3748cb44ef90f43ef8fe3816c2fd72f8aece54de93f6d46655f2887bfe848c67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dbb14eb72f52d41f84831507889ec9f5273d641ac7a9183996a24ed56d1bcbe7"
  end

  depends_on "python@3.14"

  uses_from_macos "zlib"

  def install
    # Workaround for arm64 Linux: https://github.com/mikolmogorov/Flye/pull/691
    ENV["arm_neon"] = ENV["aarch64"] = "1" if OS.linux? && Hardware::CPU.arch == :arm64

    ENV.deparallelize
    virtualenv_install_with_resources
    pkgshare.install "flye/tests/data"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/flye --version")
    cp_r pkgshare/"data/.", testpath
    system bin/"flye", "--pacbio-corr", "ecoli_500kb_reads_hifi.fastq.gz", "-o", testpath
    assert_path_exists "assembly.fasta"
  end
end
