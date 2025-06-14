class Flye < Formula
  include Language::Python::Virtualenv

  desc "De novo assembler for single molecule sequencing reads using repeat graphs"
  homepage "https://github.com/mikolmogorov/Flye"
  url "https://github.com/mikolmogorov/Flye/archive/refs/tags/2.9.6.tar.gz"
  sha256 "f05a3889b1c7aafed4cc0ed1adc1f19c22618c1c7b97ab5f80d388c8192bd32a"
  license all_of: ["BSD-3-Clause", "Apache-2.0", "BSD-2-Clause", "BSL-1.0", "MIT"]
  head "https://github.com/mikolmogorov/Flye.git", branch: "flye"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f6ff4135fbbe3045cf3bf6f1660be67fe941b86504248a8168a0d0f6b31480e2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "810af69fce87083de1a03681770ff518870625396b869d73f56940437682bc04"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "400b56515e72445dde5088a6dc0dc10be8c61c0aa5fc883183db65577d402726"
    sha256 cellar: :any_skip_relocation, sonoma:        "818c62bbff5349d4bcda667e7bfb6daad48bf90cca67843cdd82ace15340ef1e"
    sha256 cellar: :any_skip_relocation, ventura:       "ce68c98b8f26b98724c1e6ad2ccc660e96921af10dff8276e41c916aaf777d9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5455c6f8c306bc89512b1878b75b5140b98875e24a37f3154ad1a7ff66b49c0b"
  end

  depends_on "python@3.13"

  uses_from_macos "zlib"

  def install
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
