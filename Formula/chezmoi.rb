class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi.git",
      tag:      "v2.12.1",
      revision: "8714b95999fcfc7247a3ee70e4232f438b610c82"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1ecf90ff60fa2894dad1b44d047eb55a77206373360d9308ad87ea22d4af9ab1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7b9952345c37b29f40790df49b57cd51f52989f20bc909697e273af6fad3116c"
    sha256 cellar: :any_skip_relocation, monterey:       "6fbac33cad7de0b8f04386f465bb90dfafbf2f7042783c408c07693a447f31a0"
    sha256 cellar: :any_skip_relocation, big_sur:        "e396c0181213484de77c3bdd12e2035d63a55cc488a661f5b71905a4bbe60df8"
    sha256 cellar: :any_skip_relocation, catalina:       "46d925961614c78a75a36e1543dc2795a562c6fef945edb6f67dd18cef9a2543"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4b7264ff432e80358f82cf876ebfe264b285072c470fe76ea98bd921690c44aa"
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
