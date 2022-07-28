class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi.git",
      tag:      "v2.20.0",
      revision: "774eed29f7ddb9c910534d627990d63182ad0304"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5ccff56a9f7f10c0281d3f1fa8a41ac3ad163bdf3769c04e5b63cd4f4db0467a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "47c6416f13f53ea25d411dabbd4f0bdfd9eb579871cc980d149adeb8273c1a6d"
    sha256 cellar: :any_skip_relocation, monterey:       "05ae4c3e47b57794c1e030ddc86330d573e17cbdf7b9bd761abc0b2e7c488d7e"
    sha256 cellar: :any_skip_relocation, big_sur:        "75a7136e601dbb3787fa3debdcb49957714b8823b44c33f1e28f706a4e28dbb4"
    sha256 cellar: :any_skip_relocation, catalina:       "b7f771e2a575aa80adc42a6be7daae2d1905c14dbe62291bf93ae50b488ea2c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa3718d61ac6797994d29325c06f6470f157fe403d6ea8af90b711ec56f2ffbe"
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
