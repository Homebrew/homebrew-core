class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi.git",
      tag:      "v2.29.4",
      revision: "492e102f767199de065684d4a9ef6604dab3e11f"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a951156b24d1711f58a8f6532b49880750734c0e374bdadf7a1c960760aa333d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "176447e6d93e712004b0ca5e5e8576e49d2fca2eb37455f0937386097d3c3774"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "be91f15c2a8b98ef4093f355718f48c98e463117cd264ad1cd8e11b44f2c621c"
    sha256 cellar: :any_skip_relocation, ventura:        "d68313cf8ff08d7c6adefd6e8ba993aa0ab78e76b4097a8fd7fbc89796044528"
    sha256 cellar: :any_skip_relocation, monterey:       "ba3bcf90184497385ff6614f0d35fd266866597fc02646b6fa72bf0113b5c657"
    sha256 cellar: :any_skip_relocation, big_sur:        "c0527b5fdfa24e21f050f4b74749d15c47e70ff63e28a0253b3e74e7d1f2ca94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "95be0878caf734b10a04301fa80f014c34941f9cb1870704046c50725a7a54c5"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
      -X main.date=#{time.strftime("%FT%T#{time.utc? ? 'Z' : '%:z'}")}
      -X main.builtBy=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    bash_completion.install "completions/chezmoi-completion.bash"
    fish_completion.install "completions/chezmoi.fish"
    zsh_completion.install "completions/chezmoi.zsh" => "_chezmoi"

    prefix.install_metafiles
  end

  test do
    # test version to ensure that version number is embedded in binary
    assert_match "version v#{version}", shell_output("#{bin}/chezmoi --version")
    assert_match "built by #{tap.user}", shell_output("#{bin}/chezmoi --version")

    system "#{bin}/chezmoi", "init"
    assert_predicate testpath/".local/share/chezmoi", :exist?
  end
end
