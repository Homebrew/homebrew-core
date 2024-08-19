class Cheat < Formula
  desc "Create and view interactive cheat sheets for *nix commands"
  homepage "https://github.com/cheat/cheat"
  url "https://github.com/cheat/cheat/archive/refs/tags/4.4.2.tar.gz"
  sha256 "6968ffdebb7c2a8390dea45f97884af3c623cda6c2d36c4c04443ed2454da431"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6dd5285d4e42b1976c4f0f334801393e2e4773162923cd55452f802321e2f711"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9e21ab004b1cb5980cc44bca0f53b15c2faa6eafce6ddc9eca8111686fd1cd7f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1474e66acfad304ccfaac31485a8d157f9f46715abee290f762101012b75edfd"
    sha256 cellar: :any_skip_relocation, sonoma:         "5ba6469c2d181e3d0003a62b82013a1e062e83fcede817b03c3b0fe396b296fa"
    sha256 cellar: :any_skip_relocation, ventura:        "bf46ed2b17ac40f8c9fbadb38654b9ed601f825e9256975e0903fbecce3f432f"
    sha256 cellar: :any_skip_relocation, monterey:       "72b7aad552bca469ac25da221432e8cf1fdb066082d3b9772f831faf6b7e566d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "029acbb363f0d93fa5560e631262cff46147940c960283aecb0256ca7919e163"
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
