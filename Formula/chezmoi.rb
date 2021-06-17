class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi.git",
      tag:      "v2.0.15",
      revision: "d02e707857d9b7365bb3c1b18a849362876efa88"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f0133ca208d60179ea248d84ad9670d4a46789a52e21dacbf4dcbbf32d30a9c6"
    sha256 cellar: :any_skip_relocation, big_sur:       "b00782ff58ce89f449c495c0f07de5f6d010eb96e92e56c52fbc924f80161ffa"
    sha256 cellar: :any_skip_relocation, catalina:      "1073df23d7f254d7e5822ccd15b6c97629db5f4160ddf60b00ed12d8d502375b"
    sha256 cellar: :any_skip_relocation, mojave:        "d58823b2e57d40d2d7d681e97bbf1f73d7a980063a26138e803eb93fdde698ee"
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
