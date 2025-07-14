class Nb < Formula
  desc "Command-line and local web note-taking, bookmarking, and archiving"
  homepage "https://xwmx.github.io/nb"
  url "https://github.com/xwmx/nb/archive/refs/tags/7.20.1.tar.gz"
  sha256 "66ecc7b016c71152b260c589db61374fa9bfbb825f00ebea482b867727f1731d"
  license "AGPL-3.0-or-later"
  head "https://github.com/xwmx/nb.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ca27a1aa2094ff1c51523006d7c4f252ba16a5dbe43ae523eeb6b1979642ec17"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ca27a1aa2094ff1c51523006d7c4f252ba16a5dbe43ae523eeb6b1979642ec17"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ca27a1aa2094ff1c51523006d7c4f252ba16a5dbe43ae523eeb6b1979642ec17"
    sha256 cellar: :any_skip_relocation, sonoma:        "83eaae9ecc3894c21bbfe6eaa81e8ad3f4fed6bcd46d910e3aaf34e478d6e496"
    sha256 cellar: :any_skip_relocation, ventura:       "83eaae9ecc3894c21bbfe6eaa81e8ad3f4fed6bcd46d910e3aaf34e478d6e496"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ca27a1aa2094ff1c51523006d7c4f252ba16a5dbe43ae523eeb6b1979642ec17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ca27a1aa2094ff1c51523006d7c4f252ba16a5dbe43ae523eeb6b1979642ec17"
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

    bash_completion.install "etc/nb-completion.bash" => "nb"
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
