class Minimap2 < Formula
  desc "Versatile pairwise aligner for genomic and spliced nucleotide sequences"
  homepage "https://lh3.github.io/minimap2"
  url "https://github.com/lh3/minimap2/archive/refs/tags/v2.28.tar.gz"
  sha256 "5ea6683b4184b5c49f6dbaef2bc5b66155e405888a0790d1b21fd3c93e474278"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f682b5adbbae08fc261bd5050e3db95daef291d5af573975f62b0de58d7d78fc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1b2af528b6f911d1c70de8a77c146e87295a195d102448871c202bf967a24e38"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d1bf22d1d8de0c95d7387c8877f41cd6d86eda4028ab45edffb1e4332cf4173f"
    sha256 cellar: :any_skip_relocation, sonoma:         "a9bc76316ec78fe78e0e07ef7326f07de2d7fbb70cfa8cd185fb690791a2eaae"
    sha256 cellar: :any_skip_relocation, ventura:        "dd0b65b8b9c38288caa35ca86696bb02c5f6066086eb3e0ed203c02c56c4da13"
    sha256 cellar: :any_skip_relocation, monterey:       "6034231fb2326eaa195420fe5260fc959b4c374465eee57f41fded0da51af970"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "03104c16fdc1d9cb697ac848ea9d644bc9b68988f62a42b32825dd2efb79b9c9"
  end

  uses_from_macos "zlib"

  def install
    if Hardware::CPU.arm?
      system "make", "arm_neon=1", "aarch64=1"
    else
      system "make"
    end
    bin.install "minimap2"
    pkgshare.install "test"
  end

  test do
    cp_r pkgshare/"test/.", testpath
    output = shell_output("#{bin}/minimap2 -a MT-human.fa MT-orang.fa 2>&1")
    assert_match "mapped 1 sequences", output
  end
end
