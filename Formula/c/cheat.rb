class Cheat < Formula
  desc "Create and view interactive cheat sheets for *nix commands"
  homepage "https://github.com/cheat/cheat"
  url "https://github.com/cheat/cheat/archive/refs/tags/4.4.2.tar.gz"
  sha256 "6968ffdebb7c2a8390dea45f97884af3c623cda6c2d36c4c04443ed2454da431"
  license "MIT"
  head "https://github.com/cheat/cheat.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e9bdff27a92bab0dd90d21017d8e6ca8c4f09fd9d027b581775d5e091a8f861f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "892bbbee98b8e75d5368a898b7f5c3a2968f5f85a7792a4cfbe7d47ba48b811b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "892bbbee98b8e75d5368a898b7f5c3a2968f5f85a7792a4cfbe7d47ba48b811b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "892bbbee98b8e75d5368a898b7f5c3a2968f5f85a7792a4cfbe7d47ba48b811b"
    sha256 cellar: :any_skip_relocation, sonoma:        "4ce8ddab97ab046dbed22b3a584a66bf97e55246c51e1324d18c6959d32170a9"
    sha256 cellar: :any_skip_relocation, ventura:       "4ce8ddab97ab046dbed22b3a584a66bf97e55246c51e1324d18c6959d32170a9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "de9fb22d8e57c93c2b3d7209f8200d7db98507bb160db8f7285e3be0cd7b061e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "056c862aa6f3f46ba541558de9ae41a0e0c81424934830c0f1e12b4530d2692b"
  end

  depends_on "go" => :build

  conflicts_with "bash-snippets", because: "both install a `cheat` executable"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/cheat"

    bash_completion.install "scripts/cheat.bash" => "cheat"
    fish_completion.install "scripts/cheat.fish"
    zsh_completion.install "scripts/cheat.zsh" => "_cheat"
    man1.install "doc/cheat.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cheat --version")

    output = shell_output("#{bin}/cheat --init 2>&1")
    assert_match "editor: EDITOR_PATH", output
  end
end
