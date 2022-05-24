class Cheat < Formula
  desc "Create and view interactive cheat sheets for *nix commands"
  homepage "https://github.com/cheat/cheat"
  url "https://github.com/cheat/cheat/archive/4.2.3.tar.gz"
  sha256 "9624160ba542fb51bbd959d8c68b76f82ea324a6186d8d6d544b0efd8c9cc8ca"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9c42b3375ed5045a77246d43793d358ef77c9b63d0df2fcd6489432ff7e6e151"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "29bc2dffe84cddb513d2d60e975318d5711ee3c271d1df1281748dc218e55e6d"
    sha256 cellar: :any_skip_relocation, monterey:       "118c51e8357165b252d05b71fa550b43146dfa91c827c878fd2d7e96dcb5fc5e"
    sha256 cellar: :any_skip_relocation, big_sur:        "555a8eed35239df3eea18eaa0f79d420536c4b37a2c0fe1f918767fee021d813"
    sha256 cellar: :any_skip_relocation, catalina:       "4764f422ab1b50502ea727005f7b9eaf491e560bb20eb1d76088f5923dde2f67"
    sha256 cellar: :any_skip_relocation, mojave:         "61b509e154f3bb7a86c7d409d17a7aa69548c0c3815ccb2643e9e0350af98d82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "85f574d6ebd084427db1c067f98679d7f76ec922297377f073ac0f1b8b680734"
  end

  depends_on "go" => :build

  conflicts_with "bash-snippets", because: "both install a `cheat` executable"

  def install
    system "go", "build", "-mod", "vendor", "-o", bin/"cheat", "./cmd/cheat"

    bash_completion.install "scripts/cheat.bash"
    fish_completion.install "scripts/cheat.fish"
    zsh_completion.install "scripts/cheat.zsh"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cheat --version")

    output = shell_output("#{bin}/cheat --init 2>&1")
    assert_match "editor: vim", output
  end
end
