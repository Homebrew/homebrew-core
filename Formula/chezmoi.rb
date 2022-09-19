class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi.git",
      tag:      "v2.23.0",
      revision: "7481b57f40c89a777e1f13be3e1d418a8b4f5a16"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "84cb52694b6d6dc44e8117a63f23a70904583e46c75d2b768af6c11997338896"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "621e8df995dcd7bf54ad68d11c326d6d46196ebb80a48a463f11e8974caacde7"
    sha256 cellar: :any_skip_relocation, monterey:       "d9ec8e27cceb5017246f49b6e6c7008f2bcdfbf1c90c1395033abefe06defdd1"
    sha256 cellar: :any_skip_relocation, big_sur:        "575e72b3da58ca5057a0745920adee2ef7791a66b3e55177d6eeaca8234c7411"
    sha256 cellar: :any_skip_relocation, catalina:       "a25841c6ab87b74caff302496be8915b6b3f586126e27da249a2a2d87a2099ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "23516bc669a76960d209c36a8e8b02be4cf0c02ecfac5186228983985b3f7d5a"
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
