class Bwa < Formula
  desc "Burrow-Wheeler Aligner for pairwise alignment of DNA"
  homepage "https://github.com/lh3/bwa"
  url "https://github.com/lh3/bwa/archive/refs/tags/v0.7.19.tar.gz"
  sha256 "cdff5db67652c5b805a3df08c4e813a822c65791913eccfb3cf7d528588f37bc"
  license all_of: ["GPL-3.0-or-later", "MIT"]
  head "https://github.com/lh3/bwa.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cd17b7367cbda46d49bba96116e29ec1ffae87d4595bb599180608d3d2bd8f36"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5bb4e7a2c62091c64124fe181f164b3bfe693862a2d84b48774dd0478c11c5a2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2cbbb8189bf2e3a42a409777cdaaa9d00128e75b3db842c553e6686b57bdbe4e"
    sha256 cellar: :any_skip_relocation, sonoma:        "a5db6c986e2526f8857cfa30d97c7c7c685a26e936f05b2e1cca6e63b62dd262"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "11f9c38e101df4dfb8b60fce5b1f81f2a70c6728fdda14aa4c7fadea5f1b89de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "195e334b5f9c69bbbddd656bec4b6b6be44e264a20fa1379e379bc57725bd621"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  on_arm do
    depends_on "sse2neon" => :build
  end

  def install
    system "make"

    # "make install" requested 26 Dec 2017 https://github.com/lh3/bwa/issues/172
    bin.install "bwa"
    man1.install "bwa.1"
  end

  test do
    (testpath/"test.fasta").write ">0\nAGATGTGCTG\n"
    system bin/"bwa", "index", "test.fasta"
    assert_path_exists testpath/"test.fasta.bwt"
    assert_match "AGATGTGCTG", shell_output("#{bin}/bwa mem test.fasta test.fasta")
  end
end
