class Cutadapt < Formula
  include Language::Python::Virtualenv

  desc "Removes adapter sequences from sequencing reads"
  homepage "https://cutadapt.readthedocs.io"
  url "https://github.com/marcelm/cutadapt.git",
      tag:      "v5.2",
      revision: "ef852629f667637439f28761499bb56126e390a1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1b7435a5334637e1cac9fc9682aae40a0807cb52ecc8559d4cd7f127b74e185c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6191683861ae3b20d47010fe1a76def344285fd0e53878ae76949a8b131346af"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cce57d4c939e86b80f702243984b4c74b6830c4e1d7b760255820ad1c225b6b1"
    sha256 cellar: :any_skip_relocation, sonoma:        "a4d1fcf14494014bacfd1a6791252e6476762a071ac8332daa24dc875b61e3a7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5e6931901df9dc23b3858f38d1a0794052062f4e91d78cdef245ee2daac594a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "65d6ebdce3764e07bb923ed83763443dd031c48e7eed780a4d683069361e0ef5"
  end

  depends_on "python@3.14"

  on_intel do
    depends_on "nasm" => :build
  end

  resource "dnaio" do
    url "https://files.pythonhosted.org/packages/a9/f2/3b4d7f4ac4fc25742fde4c5b50ed1bc60ab731cf8cabd3089dd11e4ea1c9/dnaio-1.2.4.tar.gz"
    sha256 "a7570311f29e8b3c1ea39a60f57b7baf8dad8f2508595c58d4278c5571463166"
  end

  resource "isal" do
    url "https://files.pythonhosted.org/packages/9c/35/40ff3eabd401036f792cf55ba9cd19dcd5e3cb79aa5798332885ab0ff1b9/isal-1.8.0.tar.gz"
    sha256 "124233e9a31a62030a07aafd48c26689561926f4e10417ed3ea46c211218f2b4"
  end

  resource "xopen" do
    url "https://files.pythonhosted.org/packages/47/01/0abf3e42bb1bf15ce24e4b235b1274e0c3c9ba8e3bbf2300b6323e6f50c1/xopen-2.0.2.tar.gz"
    sha256 "f19d83de470f5a81725df0140180ec71d198311a1d7dad48f5467b4ad5df6154"
  end

  resource "zlib-ng" do
    url "https://files.pythonhosted.org/packages/46/7d/901c6e333fb031b5bfbd1532099200cf859f12aa83689be494eade6685ec/zlib_ng-1.0.0.tar.gz"
    sha256 "c753cea73f9e803c246e9bf01a59eb652897ed8a19334ada0f968394c7f61650"
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
