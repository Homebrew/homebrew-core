class Cheat < Formula
  desc "Create and view interactive cheat sheets for *nix commands"
  homepage "https://github.com/cheat/cheat"
  url "https://github.com/cheat/cheat/archive/refs/tags/4.4.1.tar.gz"
  sha256 "cca7f3d631de38ef1b4f36a5dc76d52d091611d38074ff2522a1a8b36f34a182"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9de82afae0fba66a49571b3a4a6ff88cc77ba8feed47466ecda34cb6d5e351da"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c725e96c8dd02d2525aff37625c0b787768bcab5ffe9e05c002e143a7d0d9646"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a7d95be6359e9b73ae4d1ee5c86b1dc87b05af881b77162761e300016b6303e5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9bf0464892442dcdf7830c4267e306f4022fc058c201a677f564b006d77555ef"
    sha256 cellar: :any_skip_relocation, sonoma:         "7c6c469b325b5052ca76fd2fa16e4da5484f5504cd63d43d8164a371d020df26"
    sha256 cellar: :any_skip_relocation, ventura:        "e21f97c913467e985671ec962c1c9e289c50756dd30979200beef199d9e5c14d"
    sha256 cellar: :any_skip_relocation, monterey:       "43de4fe510193020cf309c6025ac272a1481f28d5a466b311eba7c4d65402682"
    sha256 cellar: :any_skip_relocation, big_sur:        "b7bf297d1e132c1a0a33523455c6519d5ed2b003b391526fef7698179a7ef674"
    sha256 cellar: :any_skip_relocation, catalina:       "5b4d72129ec6e3e688f767458e4d3b01fb5a0189bb72f1655a13b669d11c2fc6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "646d9ab56e05a3e005e0ec99ba51255c1535527746c47980206550a5c3f17aa0"
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
    assert_match "editor: EDITOR_PATH", output
  end
end
