class Chezmoi < Formula
  desc "Manage your dotfiles across multiple machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi.git",
      tag:      "v1.8.5",
      revision: "c5dbedcf0256d6da92f774eb57e8d1d198f6e6c5"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "d2a219e5e7f459ad41bf562461108687942e513888a72663b5557ca849dcf1f0" => :catalina
    sha256 "ea6bb2de05ac3add80c4f116474137a268dbfa86a51db35a6a5f02e0183bb6d3" => :mojave
    sha256 "ab4b776fcf2c27e3042cd7f04f324730f4b620240e970696fc90b287fc816d68" => :high_sierra
  end

  depends_on "go" => :build

  def install
    commit = Utils.safe_popen_read("git", "rev-parse", "HEAD").chomp
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
