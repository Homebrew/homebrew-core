class Nb < Formula
  desc "Command-line and local web note-taking, bookmarking, and archiving"
  homepage "https://xwmx.github.io/nb"
  url "https://github.com/xwmx/nb/archive/refs/tags/7.12.1.tar.gz"
  sha256 "c9b30448751dd726469ed3fde29e618c5747eb4a16ceaaf86d773989a6cf13f3"
  license "AGPL-3.0-or-later"
  head "https://github.com/xwmx/nb.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "aa63729decb11a3499225a19aa9b3ae0925511c97d1f3f5f2c3a41d98d00886f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aa63729decb11a3499225a19aa9b3ae0925511c97d1f3f5f2c3a41d98d00886f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aa63729decb11a3499225a19aa9b3ae0925511c97d1f3f5f2c3a41d98d00886f"
    sha256 cellar: :any_skip_relocation, sonoma:         "63d5c93139111ee932b14d1e57f2a400a201c3ef70398582f6acdbd5e3bc27e5"
    sha256 cellar: :any_skip_relocation, ventura:        "63d5c93139111ee932b14d1e57f2a400a201c3ef70398582f6acdbd5e3bc27e5"
    sha256 cellar: :any_skip_relocation, monterey:       "63d5c93139111ee932b14d1e57f2a400a201c3ef70398582f6acdbd5e3bc27e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa63729decb11a3499225a19aa9b3ae0925511c97d1f3f5f2c3a41d98d00886f"
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
