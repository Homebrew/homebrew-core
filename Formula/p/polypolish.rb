class Polypolish < Formula
  desc "Short-read polishing tool for long-read assemblies"
  homepage "https://github.com/rrwick/Polypolish"
  url "https://github.com/rrwick/Polypolish/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "99ea799352cecf6723b73fb4c5c64dd2091ff1cdab6eef10309e06c642e56855"
  license "GPL-3.0-or-later"
  head "https://github.com/rrwick/Polypolish.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c1422d344c3b60428cf5e201ecbe405edad60e3f0404ce8029e3d713846220ae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0b90a3ac3ed81082d4da52cf6a596dfe61a397dac3a4e994bbea5ca3417f6476"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a8b92132e290d9acc0dfda7f77733d753a047a9300b48addb519d7da6bad1859"
    sha256 cellar: :any_skip_relocation, sonoma:        "33cb907b077ec76328435441f43a1bf57fcca5cbe2f9959ab6a30c4b21524b63"
    sha256 cellar: :any_skip_relocation, ventura:       "921305cc787de3679dada5645917f3e183e96aac6f4dccc8930adcb395eda850"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c143a0a43418cb58e4e2d09ada0938ca835b81d3257e9308bab83fb14261f26c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe3e0cff58d47896e53f46ad77f65e9ab63c6f6a1242fbd88de05584d7dad59d"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"test.fasta").write <<~EOS
      >U00096.2:1-70
      AGCTTTTCATTCTGACTGCAACGGGCAATATGTCTCTGTGTGGATTAAAAAAAGAGTGTCTGATAGCAGC
    EOS
    output = shell_output("#{bin}/polypolish polish test.fasta")
    assert_match "polypolish", output
  end
end
