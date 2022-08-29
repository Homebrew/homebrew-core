class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi.git",
      tag:      "v2.21.1",
      revision: "9f207f4f92429377387177d07e2eb55dcbc5ded5"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4dc74a5986607f6be3724afbebd7f94ed2c0005ec73f6ea30645ab1198cb4f6b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "81039f88ed18a1f86ab99f6cf5b4f7b9da7fe06a09561524b5027cbc6ef5a590"
    sha256 cellar: :any_skip_relocation, monterey:       "0575c4ac38d1902e9da0bfce6c1e2bdf90ca6bd7326aa89cb7a764733cc24f3c"
    sha256 cellar: :any_skip_relocation, big_sur:        "a4f814be0d4e9a0e9494912ff54f9c026255067a5e96d909628d8b10162ae3bb"
    sha256 cellar: :any_skip_relocation, catalina:       "da56d3201807a7f2ef944ec651450ad0b500a174e8181f3fe9e6bcb2127b86d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "66746bc6e36a6e83b493adb12fef3c7e99e70a551990fde92c6223dc7cb8c9e4"
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
