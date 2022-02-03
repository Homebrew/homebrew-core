class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi.git",
      tag:      "v2.11.2",
      revision: "13de45fdd4d2eddd3447d80c129754090fde80ac"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8b0a7dc033340c53491cea7b93eaf8eb00c0e6fa0925f1dfe1396e59edd7e58e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3f9ada056c8ea725b29dfcef5b8f4933c0df6f9536501a01785ae9abe5eea6f5"
    sha256 cellar: :any_skip_relocation, monterey:       "bdd37a88281c80c66310fd9ffa966ba3b64235321736534b5994900222b6eed2"
    sha256 cellar: :any_skip_relocation, big_sur:        "94ad80b8ee0d7fe05e767461e61b915e07c480f227f77afcc38e009fa0bddb2c"
    sha256 cellar: :any_skip_relocation, catalina:       "0d3d71c4b9bf691228b18e34a8e8bd31b667c43fd733a73fc02f91580cbc632b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b9793b5023b49299a07af0622700edb24f6346408ce18cea984f0d92c4ffd06e"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
      -X main.date=#{time.rfc3339}
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
