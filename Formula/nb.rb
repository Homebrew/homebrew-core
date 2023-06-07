class Nb < Formula
  desc "Command-line and local web note‑taking, bookmarking, and archiving"
  homepage "https://xwmx.github.io/nb"
  url "https://github.com/xwmx/nb/archive/refs/tags/7.5.1.tar.gz"
  sha256 "2e1a81f5235b8eb7c4edf2d83bfd1663ce55118699827da14a80f35e88b8bd11"
  license "AGPL-3.0-or-later"
  head "https://github.com/xwmx/nb.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3ec17f72713199815da51896ae04c5dde5c46541af55149f00c75aa44d2363d5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3ec17f72713199815da51896ae04c5dde5c46541af55149f00c75aa44d2363d5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3ec17f72713199815da51896ae04c5dde5c46541af55149f00c75aa44d2363d5"
    sha256 cellar: :any_skip_relocation, ventura:        "edda9785874bb8c7d100200e6354da7a3cd24a6be4f82501c5dd88ca3e6c4df0"
    sha256 cellar: :any_skip_relocation, monterey:       "edda9785874bb8c7d100200e6354da7a3cd24a6be4f82501c5dd88ca3e6c4df0"
    sha256 cellar: :any_skip_relocation, big_sur:        "edda9785874bb8c7d100200e6354da7a3cd24a6be4f82501c5dd88ca3e6c4df0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ec17f72713199815da51896ae04c5dde5c46541af55149f00c75aa44d2363d5"
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
