class GitCliff < Formula
  desc "Highly customizable changelog generator"
  homepage "https://github.com/orhun/git-cliff"
  url "https://github.com/orhun/git-cliff/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "045fb10ad0ee340172397f2bb6521c7ee0a83dca2c9f9d177300601f6c60184f"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "057b426b04a779d5935b8005d0d14d9ffd3a293cbc7ac900f150b18f640d424a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1dd4f2122fe4844df2b2a9fb8fb6dbf4918e4bba5d03023ba6796107dfd82f78"
    sha256 cellar: :any_skip_relocation, monterey:       "bb83b9db56690ee4b2dedf9dc13fa3bc7181fef88cdaf72098ee27492a0630a3"
    sha256 cellar: :any_skip_relocation, big_sur:        "75a885ca37c22df9e417fd037e595cb5226e643fa4d7c7e8ee42143e9550c627"
    sha256 cellar: :any_skip_relocation, catalina:       "59fe0b7593b8fb1e254cd3dd620692b01d9aee8c294ca706d93a642ca8c2cc4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d60d9be5add130a157932e76ab09a7aa1beae7dea88754b2fe1f2404873458d"
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
