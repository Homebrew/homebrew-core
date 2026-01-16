class Minimap2 < Formula
  desc "Versatile pairwise aligner for genomic and spliced nucleotide sequences"
  homepage "https://lh3.github.io/minimap2"
  url "https://github.com/lh3/minimap2/archive/refs/tags/v2.30.tar.gz"
  sha256 "4e5cd621be2b2685c5c88d9b9b169c7e036ab9fff2f3afe1a1d4091ae3176380"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "106a141d81ca4146eb67910656304caab34900a21bad667eda801f3181b397c3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "15a95a85343975c72953717d6aefcca9ee2e04f1f0a0b0403819d053c722368a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cfb5b7c1bc6595db98264d150b10cb4b1f17efcedd60a087a8f3540861679fe0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e71e6111743b87d5005094bbaa9813116922d397b7dbce5f8a7e34bba6e78ef2"
    sha256 cellar: :any_skip_relocation, sonoma:        "f29c0dadd3b8a0ac0eabb51593e2c55f9bb57a65ebea6dc5822d141e9d4b94ce"
    sha256 cellar: :any_skip_relocation, ventura:       "16e71c8e195454cc5809b874ac3ff3cbaabe4ac8cf329c17fe5c9b5cc732af8b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5ab2307d37cca517d00b5c6b2622d332c90bae19e880f3d6749b5182401f5d35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f28f740a2280da6423e032afba5109e2253f57286f779add8f2c0c52f783fff8"
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
