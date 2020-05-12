class Chezmoi < Formula
  desc "Manage your dotfiles across multiple machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi.git",
      :tag      => "v1.8.1",
      :revision => "4def4f3b96cb01cefe8d7887e8dbfb77908ef267"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "5eba88d21dad1166ee94b8e62bedb081422a9fd135baa9c46fd13f919fe2fc88" => :catalina
    sha256 "e0797f547da6c1fcbca72949ff90a1426cca4ea7b0aee18163236a3285092cb0" => :mojave
    sha256 "752015827d57013869bcdc884617468af30a506f6c22c95dd997b2fc7a6cde3e" => :high_sierra
  end

  depends_on "go" => :build

  def install
    commit = Utils.popen_read("git", "rev-parse", "HEAD").chomp
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{commit}
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
    assert_match "version #{version}", shell_output("#{bin}/chezmoi --version")
    assert_match "built by homebrew", shell_output("#{bin}/chezmoi --version")

    system "#{bin}/chezmoi", "init"
    assert_predicate testpath/".local/share/chezmoi", :exist?
  end
end
