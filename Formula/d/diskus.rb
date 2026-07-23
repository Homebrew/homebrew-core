class Diskus < Formula
  desc "Minimal, fast alternative to 'du -sh'"
  homepage "https://github.com/sharkdp/diskus"
  url "https://github.com/sharkdp/diskus/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "c4c9e4cd3cda25f55172130e3d6a58b389f0113fcefa96c73e4c80565547d1bf"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f407f4c6b4be9baf0de69a585e02509c03e1f62530300fd8e1a22da11f3fc623"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6f8667d3f87a006feba4bace59e7b7fc7ae44c8bb1d310857048ef94e2f3dba9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7142d0bb05004da604eb907d14e0c5ec9b7e08f50f00346bc2f5151c79f7f17e"
    sha256 cellar: :any_skip_relocation, sonoma:        "ea18a5c0ccbd21a8dd0032f07b85236e27c96a040952a0dd75bb869c2a023eb5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "23a66710ff84cb7d778d7941fb80f24433644fb143474f3fc6eb8cb0bcbfcbe7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "826a59a9dbbe4d4c24e3627df7a82b654321768c0b9faa0bba5ca480ad010dfa"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "doc/diskus.1"
  end

  test do
    (testpath/"test.txt").write("Hello World")
    output = shell_output("#{bin}/diskus #{testpath}/test.txt")
    assert_match "4096", output
  end
end
