class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi.git",
      tag:      "v2.0.15",
      revision: "d02e707857d9b7365bb3c1b18a849362876efa88"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "37754482616b37d7cefe17a891adde5833721cb9343041e91de7f2f72c2ddf50"
    sha256 cellar: :any_skip_relocation, big_sur:       "a6bf2a7b74396c27c83a12366d1cc399e0c844b48513fc53b14ae469b09955e9"
    sha256 cellar: :any_skip_relocation, catalina:      "140b1f94488f5325c3e4212cfbf4565fd73331cd55041186464a2ff1d5f5c191"
    sha256 cellar: :any_skip_relocation, mojave:        "03ba8dcba8eca892dc76b47d7c918c148a9cfbf440ee40b088c2303eb58837c5"
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
