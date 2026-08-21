class Minimap2 < Formula
  desc "Versatile pairwise aligner for genomic and spliced nucleotide sequences"
  homepage "https://lh3.github.io/minimap2"
  url "https://github.com/lh3/minimap2/archive/refs/tags/v2.31.tar.gz"
  sha256 "bff334a0e4512644e2f3e29944aeec408f49450f4f74dc39fe89e5273869255b"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a0621571925138e90e219a9aaac5595a5b332a6ac9bba3357f360bcb579b89f0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c9a4c3f4ca1b3418eabfb36b56c4b51c1349df8fd1dae21155a53d988a792ee1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9e74099060a600ccc2946c0405ea2ad833d3513e75c6ce99c997fd68c0547757"
    sha256 cellar: :any_skip_relocation, sonoma:        "61ee86a03797524d2196ab430ab57eab6a92eff05981c938c5e9787c6e953b52"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9d408197f553ea716ff31cbff5edaee823fed53bb935506df310f1a01a5c039e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e87deffaa0770d2b223a8a820238d6478790e1616a66f37bdc15f2a2d7d81a73"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
