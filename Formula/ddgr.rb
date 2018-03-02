class Ddgr < Formula
  desc "DuckDuckGo from the terminal"
  homepage "https://github.com/jarun/ddgr"
  url "https://github.com/jarun/ddgr/archive/v1.2.tar.gz"
  sha256 "a9828b8863949dc93dd574a15b6779d9390b6f5e277e35c157064d7c06423758"
  revision 2

  bottle do
    cellar :any_skip_relocation
    sha256 "ea209eb559fa4213002c5b3704f54bdd6e2a1f32095b299aee240a8d015fc6bf" => :high_sierra
    sha256 "ea209eb559fa4213002c5b3704f54bdd6e2a1f32095b299aee240a8d015fc6bf" => :sierra
    sha256 "ea209eb559fa4213002c5b3704f54bdd6e2a1f32095b299aee240a8d015fc6bf" => :el_capitan
  end

  depends_on "python"

  def install
    system "make", "install", "PREFIX=#{prefix}"
    bash_completion.install "auto-completion/bash/ddgr-completion.bash"
    fish_completion.install "auto-completion/fish/ddgr.fish"
    zsh_completion.install "auto-completion/zsh/_ddgr"
  end

  test do
    ENV["PYTHONIOENCODING"] = "utf-8"
    assert_match "Homebrew", shell_output("#{bin}/ddgr --noprompt Homebrew")
  end
end
