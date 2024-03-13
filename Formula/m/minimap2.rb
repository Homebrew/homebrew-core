class Minimap2 < Formula
  desc "Versatile pairwise aligner for genomic and spliced nucleotide sequences"
  homepage "https://lh3.github.io/minimap2"
  url "https://github.com/lh3/minimap2/archive/refs/tags/v2.27.tar.gz"
  sha256 "ca9ceb07e3b388858ebc2d7d91a6c74e996659402d16aa759ecedd63588b1ef7"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d60154934409665d6837f301a651e0008c0c30d82b13c43520ae590fa6f08d7e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2fac2191822f597856d08dc0ebe8140fead7b1ad69449b142318c8565a5783cf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b7d4c7d2de5060e2e2c6cad063589e0fe4b85a029f0f4059370d2343549f2b50"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f33f5b2a19c70d088a2008b47bb8f310ee92340eebbb37458d84881a8d9f1068"
    sha256 cellar: :any_skip_relocation, sonoma:         "c6d80ed540146f49cb133f0e4b22cae9cacb8bd6a1b3fe319b7738cf5301aafb"
    sha256 cellar: :any_skip_relocation, ventura:        "e2aeff2e9f605b4310d03a8ac36791688537e19c712c640fe4b2065a87037c52"
    sha256 cellar: :any_skip_relocation, monterey:       "4371d29b25df3ebb4a44b93f7d6cc99581a533537f9a83566d935e4e53c770ff"
    sha256 cellar: :any_skip_relocation, big_sur:        "d3b4a714519502f6336dbf7c1d40b17532f4ca00bc428065bcedabbfe08c3c5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "64a3fd304a3250c54bd8be2037ba13565bd055c07f0adccc40b66a679b91f4af"
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
