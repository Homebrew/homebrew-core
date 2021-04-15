class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi.git",
      tag:      "v2.0.10",
      revision: "3782e9330712b143a3c6383ea171091784fa2de3"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b69dcb8fe67d45871edd6cd584d07dfd4552b34e4eea48d018886f2c5c30ceb9"
    sha256 cellar: :any_skip_relocation, big_sur:       "5f672038d174d2980ac38079397be44432ac17b28f30f257a13db356f1e6638f"
    sha256 cellar: :any_skip_relocation, catalina:      "12293263380c9da027b3b172a8df757e11180dedb092724655730ada76d2f9fd"
    sha256 cellar: :any_skip_relocation, mojave:        "d2d5115645a279381787d2d5a0118c2309e81c4e3654fd5b10844132b091119f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
      -X main.date=#{Time.now.utc.rfc3339}
      -X main.builtBy=homebrew
    ].join(" ")
    system "go", "build", *std_go_args, "-ldflags", ldflags

    bash_completion.install "completions/chezmoi-completion.bash"
    fish_completion.install "completions/chezmoi.fish"
    zsh_completion.install "completions/chezmoi.zsh" => "_chezmoi"

    prefix.install_metafiles
  end

  test do
    # test version to ensure that version number is embedded in binary
    assert_match "version v#{version}", shell_output("#{bin}/chezmoi --version")
    assert_match "built by homebrew", shell_output("#{bin}/chezmoi --version")

    system "#{bin}/chezmoi", "init"
    assert_predicate testpath/".local/share/chezmoi", :exist?
  end
end
