class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi.git",
      tag:      "v2.7.2",
      revision: "ba9f8d31ea8542df2b51d00d927b301100cb1689"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "54df4476e8027a1be2e0a8f78a41501e85f2f7706824bfc908d485bf8466fdc7"
    sha256 cellar: :any_skip_relocation, big_sur:       "d193d760f002a14f0061cd5f9c759fadce3730732862cffe7645700988cecee1"
    sha256 cellar: :any_skip_relocation, catalina:      "618ca781b867379ccc83df7fbcf52ed853ae49db0cdb60413de05c3790dc0ec6"
    sha256 cellar: :any_skip_relocation, mojave:        "c672971df1a9c216fe414f48cc1f8164c1bab59423054f1853c368c56502780d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "574055030888695386f9c0a8bc40a4aa4d1116ee1d0429681ba636a8cbf6ce9f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
      -X main.date=#{time.rfc3339}
      -X main.builtBy=#{tap.user}
    ].join(" ")
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
