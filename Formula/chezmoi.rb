class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi.git",
      tag:      "v2.0.5",
      revision: "d75f733160d40f26e9e8f196bad8464372cc1800"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5d79a5ed39afd03118d039948779fcf0f2dc4ab134e3dcaa76d548b73cb4a52b"
    sha256 cellar: :any_skip_relocation, big_sur:       "5da554c6fc3287ff248034b27a03f56fe8ab6dae1d7c92b9858bc8ae8d1cfb57"
    sha256 cellar: :any_skip_relocation, catalina:      "777949f256f4f734c4fb4dccb1b19590830a6995f41086264ed50ef3626ffcfc"
    sha256 cellar: :any_skip_relocation, mojave:        "6f4f9f97d6dbc588de6ed7d35821f092b749f69ccbe814f9b1bc5bec1edaade4"
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
