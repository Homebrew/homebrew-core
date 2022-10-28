class Nb < Formula
  desc "Command-line and local web note‑taking, bookmarking, and archiving"
  homepage "https://xwmx.github.io/nb"
  url "https://github.com/xwmx/nb/archive/refs/tags/7.0.1.tar.gz"
  sha256 "0ed203e6999d30dc321da9fd67a091675edadfb7f44d4dc90a151051f86d9644"
  license "AGPL-3.0-or-later"
  head "https://github.com/xwmx/nb.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "899e7782909c598227c79b347a21cb8c0daa785ae222bd23428398e4c132626a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "899e7782909c598227c79b347a21cb8c0daa785ae222bd23428398e4c132626a"
    sha256 cellar: :any_skip_relocation, monterey:       "b5c20ba7557711f043930e8da6cbc06c037f1f579989d58d71e276a04cc4ad66"
    sha256 cellar: :any_skip_relocation, big_sur:        "b5c20ba7557711f043930e8da6cbc06c037f1f579989d58d71e276a04cc4ad66"
    sha256 cellar: :any_skip_relocation, catalina:       "b5c20ba7557711f043930e8da6cbc06c037f1f579989d58d71e276a04cc4ad66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "899e7782909c598227c79b347a21cb8c0daa785ae222bd23428398e4c132626a"
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
