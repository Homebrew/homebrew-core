class Chezmoi < Formula
  desc "Manage your dotfiles across multiple machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi.git",
      :tag      => "v1.8.0",
      :revision => "017a83f4055a98ac90b030d5739aa560dde239b7"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "55192586a5d4287885b7a2de6fd94dd002f074480ec99077ca0215b5d255ae0b" => :catalina
    sha256 "08a42d8e4fc5920be533353ae3a7701bd45ebe6da8370ea7aa02e287c2de2f34" => :mojave
    sha256 "f3d02bc4834d30f8100054ea90d6fe45133bde1d431a052fa1dfa591ef5cad0b" => :high_sierra
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
    zsh_completion.install "completions/chezmoi.zsh"

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
