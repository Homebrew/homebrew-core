class Cutadapt < Formula
  include Language::Python::Virtualenv

  desc "Removes adapter sequences from sequencing reads"
  homepage "https://cutadapt.readthedocs.io"
  url "https://github.com/marcelm/cutadapt.git",
      tag:      "v5.2",
      revision: "ef852629f667637439f28761499bb56126e390a1"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "82b1a218e71c6a6064949edf56bc918103c7b8afcec3b89fcf16be8a10014d5e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "fcd8478351c67f2ff26dc78dc11cda886607417dfe8b4870859a750503106fd0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ec95a806a3a9cb72096e44994d171fdc808c3dc6f1ed6b881c60b9489daeb336"
    sha256 cellar: :any,                 arm64_linux:       "610c0b03ee24b604c8c3c156a468979908a3ccab8ca59bd2c64bdc6c1ecd45e9"
    sha256 cellar: :any,                 x86_64_linux:      "2f6856e9492fe390de00d94a86ef82589e2d28648d7f4619026729198cfcb33f"
  end

  depends_on "python@3.15"

  on_intel do
    depends_on "nasm" => :build
  end

  resource "dnaio" do
    url "https://files.pythonhosted.org/packages/a9/f2/3b4d7f4ac4fc25742fde4c5b50ed1bc60ab731cf8cabd3089dd11e4ea1c9/dnaio-1.2.4.tar.gz"
    sha256 "a7570311f29e8b3c1ea39a60f57b7baf8dad8f2508595c58d4278c5571463166"
  end

  resource "xopen" do
    url "https://files.pythonhosted.org/packages/77/bb/74a5222fc975fccb9f8bfb62613ca42a5a28008362c598df09806ecd12c1/xopen-2.1.0.tar.gz"
    sha256 "06584821588f813563863b63d5e02568a4328661b7507ea38c432f24c69ea4b7"
  end

  def install
    virtualenv_install_with_resources
    pkgshare.install "tests/data"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cutadapt --version")

    system bin/"cutadapt", "-a", "AACCGGTT", "-o", "output.fastq", pkgshare/"data/small.fastq.gz"
    assert_path_exists "output.fastq"
  end
end
