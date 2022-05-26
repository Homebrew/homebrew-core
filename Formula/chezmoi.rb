class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi.git",
      tag:      "v2.17.0",
      revision: "7c70bff83d7c1dbe9ed3be486e3a6023e05c5426"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2886dd70e608d8d3708aae3c72a17d013dc85c5a007d45a670dc43f5edfd2c84"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e1cb5608a1276a74852988bed57772224574bdf5b31352719060582042376060"
    sha256 cellar: :any_skip_relocation, monterey:       "9bf3fc631e28855d976674280ef71a3f93cb09d6f66994596b61df26b44bcb28"
    sha256 cellar: :any_skip_relocation, big_sur:        "a7f6aa6299e482ccbb77c43388c6d1697f982c6bad267acb0a3d536b000341b7"
    sha256 cellar: :any_skip_relocation, catalina:       "1c04edaee09b0a5d0e6da54c9dface0ba20410ccdb00ec4e1ac23a3818428512"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e67a54820bc785bb3776a06e3eed917d2f66812686d02d1435cf29e0599dd16a"
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
