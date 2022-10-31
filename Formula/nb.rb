class Nb < Formula
  desc "Command-line and local web note‑taking, bookmarking, and archiving"
  homepage "https://xwmx.github.io/nb"
  url "https://github.com/xwmx/nb/archive/refs/tags/7.1.1.tar.gz"
  sha256 "45ce1481771711fd31e63928f9e770caae5896ff59e9133d545e107c99252197"
  license "AGPL-3.0-or-later"
  head "https://github.com/xwmx/nb.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c4f3403cd395c4922e00a8932fbee7a6a35e93454b6a8bf6d66caa86a0a06a60"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c4f3403cd395c4922e00a8932fbee7a6a35e93454b6a8bf6d66caa86a0a06a60"
    sha256 cellar: :any_skip_relocation, monterey:       "6b016fd085c9650b6d8033aae130a11316deff7cc93393f59b714f7b1383e9a8"
    sha256 cellar: :any_skip_relocation, big_sur:        "6b016fd085c9650b6d8033aae130a11316deff7cc93393f59b714f7b1383e9a8"
    sha256 cellar: :any_skip_relocation, catalina:       "6b016fd085c9650b6d8033aae130a11316deff7cc93393f59b714f7b1383e9a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c4f3403cd395c4922e00a8932fbee7a6a35e93454b6a8bf6d66caa86a0a06a60"
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
