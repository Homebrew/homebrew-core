class Minimap2 < Formula
  desc "Versatile pairwise aligner for genomic and spliced nucleotide sequences"
  homepage "https://lh3.github.io/minimap2"
  url "https://github.com/lh3/minimap2/archive/refs/tags/v2.29.tar.gz"
  sha256 "008d5e9848b918e4eb09d054aa3d6c272d50e92b8fc8537abf5081a507019718"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a17ef19c327d33af21ce663a5c00e731b427ce5539a4fd444c69d08ed13ac031"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "02c4899b062bf0c3bd592ffdc4ebfcab5061468533230c6c1fea0c7cd1fc04bf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f8dbbb0a2e1de72ee94b40027b7efcc23a49e8ec71fea90737e71e3df0d78c92"
    sha256 cellar: :any_skip_relocation, sonoma:        "1451d3de7af2dd6f59cb1612f218c78c89be826afb339f36223d15454de33eda"
    sha256 cellar: :any_skip_relocation, ventura:       "820288efa0f55a08807d60affff35dd8853caba901878b4db15e1597d8d20284"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0796c7908c2694f083f9159dc476820ad29fed7caff4a4a5c471bfb6357f7a77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3543ef1808df306f48f1677511c6eb81109ca635f5873f521480f61eaef56a7c"
  end

  uses_from_macos "zlib"

  def install
    if Hardware::CPU.arm?
      system "make", "arm_neon=1", "aarch64=1", "extra"
    else
      system "make", "extra"
    end
    bin.install "minimap2", "sdust"
    pkgshare.install "test"
  end

  test do
    cp_r pkgshare/"test/.", testpath
    output = shell_output("#{bin}/minimap2 -a MT-human.fa MT-orang.fa 2>&1")
    assert_match "mapped 1 sequences", output
  end
end
