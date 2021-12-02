class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi.git",
      tag:      "v2.9.2",
      revision: "9c082e4fe4b74ec9909d1244f29eaacc26b20b1b"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5493c40f486ede6207b6da0fce5f44a422cbfce84d5e22c87f2f10f1c2faea2a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e40bf8b3c5ec318d4bce737ab8ebd4f43cf88c5907336ef3cfe15b0e64ab8e20"
    sha256 cellar: :any_skip_relocation, monterey:       "782eb889741251191d0eed55064762ec411907985e5797f0e4877b32288e2c3d"
    sha256 cellar: :any_skip_relocation, big_sur:        "91b1fd796e14d8d072d09acf95dd128d21f1820af10d008fa13d574bf4030f46"
    sha256 cellar: :any_skip_relocation, catalina:       "7203a1f568dfc4b1babd5fa68c74a1f0210b568382e615f68d8c874039c530e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d13ced2e70ee03ae45f9ac9f0d8ce92b6e1ca04ae5ab0a55849156a7a9f81fae"
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
