class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi.git",
      tag:      "v2.9.4",
      revision: "7f0702503528fb708a5d9fc7b2a826decb777b26"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8b3651b00d9122e5f07e1b8ea393f6c9abed3e414c247d660aaec1bb5bd2e954"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ec0385eb0de5002eadff8618bd450d7e12a8f46e33121c6f11e9d55a15ade35c"
    sha256 cellar: :any_skip_relocation, monterey:       "7921f9e2c94cdcbb88656c8570df6df87dbc4c58399b36f15dd15452e75f5b9a"
    sha256 cellar: :any_skip_relocation, big_sur:        "c21ba9d52185820ee492eaae47099ac07aef3c56f1b65a4744f1d106fe231883"
    sha256 cellar: :any_skip_relocation, catalina:       "3922dca4afc13a753ac9628d324624d6d2f7659062dc14d2e19364a117872540"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "423470d44056bcd17697e72d5b2cb0dee6ad4a9ab876144669a4406e194dc859"
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
