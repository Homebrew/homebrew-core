class Nb < Formula
  desc "Command-line and local web note‑taking, bookmarking, and archiving"
  homepage "https://xwmx.github.io/nb"
  url "https://github.com/xwmx/nb.git",
      tag:      "6.11.1",
      revision: "f3b2b6757f523c25d67d8e4f1cde6e376960a324"
  license "AGPL-3.0-or-later"
  head "https://github.com/xwmx/nb.git", branch: "master"

  depends_on "bat"
  depends_on "nmap"
  depends_on "pandoc"
  depends_on "ripgrep"
  depends_on "tig"
  depends_on "w3m"

  uses_from_macos "bash"
  uses_from_macos "git"

  def install
    bin.install "nb", "bin/bookmark"

    bash_completion.install "etc/nb-completion.bash" => "nb.bash"
    zsh_completion.install "etc/nb-completion.zsh" => "_nb"
    fish_completion.install "etc/nb-completion.fish" => "nb.fish"
  end

  test do
    assert_match version.to_s, shell_output("nb version")

    system "yes | nb notebooks init"
    system "nb", "add", "test", "note"
    assert_match "test note", shell_output("nb ls")
    assert_match "test note", shell_output("nb show 1")
    assert_match "1", shell_output("nb search test")
  end
end
