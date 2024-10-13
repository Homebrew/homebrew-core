class Nb < Formula
  desc "Command-line and local web note-taking, bookmarking, and archiving"
  homepage "https://xwmx.github.io/nb"
  url "https://github.com/xwmx/nb/archive/refs/tags/7.14.4.tar.gz"
  sha256 "d5d0291270b7f27c891dee581a91176afad1bdb3722cfe7120f0b48caf5dbf71"
  license "AGPL-3.0-or-later"
  head "https://github.com/xwmx/nb.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "447202a151df72646b4b7e354cb0b134a05a62a3c4c753cec34e4e7df0ee7492"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "447202a151df72646b4b7e354cb0b134a05a62a3c4c753cec34e4e7df0ee7492"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "447202a151df72646b4b7e354cb0b134a05a62a3c4c753cec34e4e7df0ee7492"
    sha256 cellar: :any_skip_relocation, sonoma:        "1fc5af3fee45a9c7c0fe40d1e05631fae20ebd215b9b93ef576e1226ac3e788c"
    sha256 cellar: :any_skip_relocation, ventura:       "1fc5af3fee45a9c7c0fe40d1e05631fae20ebd215b9b93ef576e1226ac3e788c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "447202a151df72646b4b7e354cb0b134a05a62a3c4c753cec34e4e7df0ee7492"
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
