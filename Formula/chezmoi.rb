class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi.git",
      tag:      "v2.29.1",
      revision: "5e7063ec11bb85efcf8e0c152dcd7dd674ed2d90"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1d943eb4ea79927d981d3dbc9cb464ffb05b7964acf7cb9b5e7b187eadcbfa78"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4696f8f93863d526a0f0d8ca5da1e0cdcdee7e53d3332ef62fe27a95631c8d89"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "17fe19969242d117d47a28ef23d5626ef1c6c9ee6fb73795d9a01e515277f830"
    sha256 cellar: :any_skip_relocation, ventura:        "8be1016cbe3545a54e4c0cfe42ec804261aec19bd79410bb1e446872fae62aeb"
    sha256 cellar: :any_skip_relocation, monterey:       "ab5eee4a39c9ee8c41614a2832a5439fd1f3dfca9535b97e8b449bfbba7b2503"
    sha256 cellar: :any_skip_relocation, big_sur:        "9d6f2102d6bb4d96e77b1a4e48baa155e420e598a1fdb4f284f36f7233716828"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "889621935cdeaa45d5fa7ca442305c54b706df6827cb12fcde73605e3e65fac4"
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
