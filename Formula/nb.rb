class Nb < Formula
  desc "Command-line and local web note‑taking, bookmarking, and archiving"
  homepage "https://xwmx.github.io/nb"
  url "https://github.com/xwmx/nb/archive/refs/tags/7.4.1.tar.gz"
  sha256 "962ae29a06bb7bff5baa317d2785622c60f656faed33b380801d8cf5572a9e4e"
  license "AGPL-3.0-or-later"
  head "https://github.com/xwmx/nb.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cfa678a6ae2885642dbb848a3f7d25c78705845d73c6025a33e7d5d8baee86a9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cfa678a6ae2885642dbb848a3f7d25c78705845d73c6025a33e7d5d8baee86a9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cfa678a6ae2885642dbb848a3f7d25c78705845d73c6025a33e7d5d8baee86a9"
    sha256 cellar: :any_skip_relocation, ventura:        "ca2eadd174eed344937c6603b0ad1cdc627392ad85fd5a6b91cee4670255cd35"
    sha256 cellar: :any_skip_relocation, monterey:       "ca2eadd174eed344937c6603b0ad1cdc627392ad85fd5a6b91cee4670255cd35"
    sha256 cellar: :any_skip_relocation, big_sur:        "ca2eadd174eed344937c6603b0ad1cdc627392ad85fd5a6b91cee4670255cd35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cfa678a6ae2885642dbb848a3f7d25c78705845d73c6025a33e7d5d8baee86a9"
  end

  depends_on "bat"
  depends_on "nmap"
  depends_on "pandoc"
  depends_on "ripgrep"
  depends_on "tig"
  depends_on "w3m"

  uses_from_macos "bash"

  def install
    bin.install "nb", "bin/bookmark"

    bash_completion.install "etc/nb-completion.bash" => "nb.bash"
    zsh_completion.install "etc/nb-completion.zsh" => "_nb"
    fish_completion.install "etc/nb-completion.fish" => "nb.fish"
  end

  test do
    # EDITOR must be set to a non-empty value for ubuntu-latest to pass tests!
    ENV["EDITOR"] = "placeholder"

    assert_match version.to_s, shell_output("#{bin}/nb version")

    system "yes | #{bin}/nb notebooks init"
    system bin/"nb", "add", "test", "note"
    assert_match "test note", shell_output("#{bin}/nb ls")
    assert_match "test note", shell_output("#{bin}/nb show 1")
    assert_match "1", shell_output("#{bin}/nb search test")
  end
end
