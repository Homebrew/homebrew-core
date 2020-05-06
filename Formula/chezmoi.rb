class Chezmoi < Formula
  desc "Manage your dotfiles across multiple machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi.git",
      :tag      => "v1.8.1",
      :revision => "4def4f3b96cb01cefe8d7887e8dbfb77908ef267"

  bottle do
    cellar :any_skip_relocation
    sha256 "5cc7963049cf98fdb7bf92a99d3de7509e04c50d6519618d6a190d61e209fd7b" => :catalina
    sha256 "0318dc5f9e3b4ff6dfa256bfebfa8b8e7b4cb16359ebb5b615977c3bc20e956b" => :mojave
    sha256 "6c790ed8bbc68733d44239fc336746b549c9fa585afcfca0961897f4594c83af" => :high_sierra
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
