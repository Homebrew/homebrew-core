class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi.git",
      tag:      "v2.22.0",
      revision: "d700e63c61a7c82f5bfb0c4e2cabcd1456dfa473"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2890cb6c400297c387984bfe9e71d48a369c83e814c25c26ccb2a51cbe68498e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3730ee85188cf42a2c7d40b78ac92a0fa53d7798a3b964f2539854ab924f2741"
    sha256 cellar: :any_skip_relocation, monterey:       "cbce63996d9412ab3603b4eb1f13e8dd1637606f816dafbcc3df0d60b0750a6a"
    sha256 cellar: :any_skip_relocation, big_sur:        "cdf3ce04e2d4712e629ccc22fc77dc549e2bb4838efa746db542daeb55260016"
    sha256 cellar: :any_skip_relocation, catalina:       "4865aef036a811d10e49c7c88d5c1e8b3fc418116bd582e3db2c0d4f4ae51974"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2a9552b035341353f3a8ff23368d7c2566504233250a32354c40d902581a96e2"
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
