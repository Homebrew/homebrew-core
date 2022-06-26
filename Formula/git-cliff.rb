class GitCliff < Formula
  desc "Highly customizable changelog generator"
  homepage "https://github.com/orhun/git-cliff"
  url "https://github.com/orhun/git-cliff/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "e4c643fd6e75416f13f6c39ef8baecfe1de1c1c09455b8055510b8a273fbf48f"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6a154e5427a37b44c82dca247300b4d735c8743f42d9ddf43581064b3fcc76cf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a9228cd50ff68a392a8520c36f28ff74d7b072240ae4383db59caaa48d12ea10"
    sha256 cellar: :any_skip_relocation, monterey:       "7f426e74a8e31dde6d6d483bac57636fbd0fc80aab36dfec55d711393b1dc481"
    sha256 cellar: :any_skip_relocation, big_sur:        "09d3eb1ca9a1534a51d895e0c5187050a5900beb4692c1efd793b8cda3831457"
    sha256 cellar: :any_skip_relocation, catalina:       "012966ffbf92230ba17ea3fdc00fd2b6eb73d92df023a7ac410e0630d862a91e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f312fd4178c25de2f766ebd3207043475f013ea3f75d75d15fe7b8cdcf871148"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args(path: "git-cliff")

    ENV["OUT_DIR"] = buildpath
    system bin/"git-cliff-completions"
    bash_completion.install "git-cliff.bash"
    fish_completion.install "git-cliff.fish"
    zsh_completion.install "_git-cliff"
  end

  test do
    system "git", "cliff", "--init"
    assert_predicate testpath/"cliff.toml", :exist?

    system "git", "init"
    system "git", "add", "cliff.toml"
    system "git", "commit", "-m", "chore: initial commit"
    changelog = "### Miscellaneous Tasks\n\n- Initial commit"
    assert_match changelog, shell_output("git cliff")
  end
end
