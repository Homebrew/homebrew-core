class Moar < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moar"
  url "https://github.com/walles/moar/archive/refs/tags/v1.31.2.tar.gz"
  sha256 "f88f244c18ee1a8ba1428bc195f9140d53a551124cc8b54c0c7942ba6433e2d7"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3ec37c865ebf0fec3331ef2c86c62d7df795e7b6b15703db29975da6b4736a30"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3ec37c865ebf0fec3331ef2c86c62d7df795e7b6b15703db29975da6b4736a30"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3ec37c865ebf0fec3331ef2c86c62d7df795e7b6b15703db29975da6b4736a30"
    sha256 cellar: :any_skip_relocation, sonoma:        "6780d7ecdda78bb9cf06fd15bb07986350a792af55aa6cf8f7ed4ebd63c2300c"
    sha256 cellar: :any_skip_relocation, ventura:       "6780d7ecdda78bb9cf06fd15bb07986350a792af55aa6cf8f7ed4ebd63c2300c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d32e25a43866babf342ab883c03c25628f4888c4eeea148e669acca7f1a4b47f"
  end

  depends_on "go" => :build

  conflicts_with "moarvm", "rakudo-star", because: "both install `moar` binaries"

  def install
    ldflags = "-s -w -X main.versionString=v#{version}"
    system "go", "build", *std_go_args(ldflags:)
    man1.install "moar.1"
  end

  test do
    # Test piping text through moar
    (testpath/"test.txt").write <<~EOS
      tyre kicking
    EOS
    assert_equal "tyre kicking", shell_output("#{bin}/moar test.txt").strip
  end
end
