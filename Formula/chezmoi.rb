class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi.git",
      tag:      "v2.0.2",
      revision: "f5a63291beaf3b3b18dc93890d9d08ad5558f2ec"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f16b7e710c8e2bd49e272e7d5800c1561a65a3f3c92ccc3beb72c080f99d667a"
    sha256 cellar: :any_skip_relocation, big_sur:       "a8dac0cddec9b8a6c4260d9460bf1c635ecb0633957431b9e336e2e574679c1b"
    sha256 cellar: :any_skip_relocation, catalina:      "8d1fa3982b87cf5ee866feec985d9feb8a8c4ab3e12721fdc4b9ea1dac32fbf0"
    sha256 cellar: :any_skip_relocation, mojave:        "91ee46018d541604ae171b0c5ef521fdec79d175a925aefdc8b63b2add643598"
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
