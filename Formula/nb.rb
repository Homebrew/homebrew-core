class Nb < Formula
  desc "Command-line and local web note‑taking, bookmarking, and archiving"
  homepage "https://xwmx.github.io/nb"
  url "https://github.com/xwmx/nb/archive/refs/tags/7.3.0.tar.gz"
  sha256 "7ba8b03f56be04a3f272fac651e3bd93a14b15b79bc351f07191e204c521843d"
  license "AGPL-3.0-or-later"
  head "https://github.com/xwmx/nb.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "715e4fd32b7445c83ae96ab76de63fb4ae8fb9ff0182813ae30ffece49c91fa1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "715e4fd32b7445c83ae96ab76de63fb4ae8fb9ff0182813ae30ffece49c91fa1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "715e4fd32b7445c83ae96ab76de63fb4ae8fb9ff0182813ae30ffece49c91fa1"
    sha256 cellar: :any_skip_relocation, ventura:        "c6d607191697c3c2a8a7c506abf1b614e3eb440e5bf81167bd455dcb4d2d3a1a"
    sha256 cellar: :any_skip_relocation, monterey:       "c6d607191697c3c2a8a7c506abf1b614e3eb440e5bf81167bd455dcb4d2d3a1a"
    sha256 cellar: :any_skip_relocation, big_sur:        "c6d607191697c3c2a8a7c506abf1b614e3eb440e5bf81167bd455dcb4d2d3a1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "715e4fd32b7445c83ae96ab76de63fb4ae8fb9ff0182813ae30ffece49c91fa1"
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
