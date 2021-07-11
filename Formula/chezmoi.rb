class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi.git",
      tag:      "v2.1.1",
      revision: "4b428e8f2a80c64562fb0fecee60cf25c0b91db1"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8a4352fa083f579e5a0f1caa223f50d8c05248a18667767baf889705db7c2c6f"
    sha256 cellar: :any_skip_relocation, big_sur:       "9193f41d7592778f86324120ab0ea5738b9eba88ad358cb67132cd9c0b76eb75"
    sha256 cellar: :any_skip_relocation, catalina:      "cecf4a68731a13c55917e658f536de1f774397709a752fc71cd2402ff03437d6"
    sha256 cellar: :any_skip_relocation, mojave:        "0acf6b6df4d3333ea2c983535f87b02e77ecea2d8467843bc50d861139ce34f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "668db7e7b94869dfaa0d99211e005ea5194927c5b01d4bae891150656b5e1b0f"
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
