class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi.git",
      tag:      "v2.15.0",
      revision: "702cc4db2e19ebd246df58a54522d30959d18cd5"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1318f8b51deaa22d89ed4fa90a130f7c92e07c704e3ce145e008e26599f4be4f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "57cfcc576ac4eeaee6b26fb0e8247df18df846595fb4fbbf7602baca42edd842"
    sha256 cellar: :any_skip_relocation, monterey:       "934bb9d095202021148adec9d77c52930353052a2f48de4a9ce52b1f683d3037"
    sha256 cellar: :any_skip_relocation, big_sur:        "b3cb355e12ca6852ebbd6db744adcd051d05cbda72a90789e34530b873c1c45c"
    sha256 cellar: :any_skip_relocation, catalina:       "d2f48858cb7feab826ae758e35d3d98fe80627eeac21f2f1784699522aec2b5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "09f202918206a57b70786d2b961a792cc491cd6e340520959ba7cb946732654f"
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
