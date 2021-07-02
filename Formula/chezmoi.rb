class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi.git",
      tag:      "v2.1.0",
      revision: "509bda706a9046c36d14fc84ba93d4dc975a7171"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2b6379790d28b4ec913699d405cc795907bd58d8714f54b40b1a4488ba675e91"
    sha256 cellar: :any_skip_relocation, big_sur:       "f6ea7f5c71a89ba842bdf669464124831532cdf2f67420510204e999ea4a8d35"
    sha256 cellar: :any_skip_relocation, catalina:      "40f12952470433131ff68c3def97da0e80f095d18766e333a74e78a7fb6edbf0"
    sha256 cellar: :any_skip_relocation, mojave:        "175bcb96cee3a4c06f2285c8872e2fa72db3c45bb2a6cc03a96feedaa71b2733"
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
