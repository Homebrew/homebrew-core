class Nb < Formula
  desc "Command-line and local web note-taking, bookmarking, and archiving"
  homepage "https://xwmx.github.io/nb"
  url "https://github.com/xwmx/nb/archive/refs/tags/7.14.5.tar.gz"
  sha256 "1927cfbc6deb99ba0a4e26f2fd7d50f2e0f05dad41269ba12a6166b5b6976c77"
  license "AGPL-3.0-or-later"
  head "https://github.com/xwmx/nb.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4636e8f586ca8f4aab67ac12636f5e9e45b5a8db06fb90a6b5272ea2ff1fe86a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4636e8f586ca8f4aab67ac12636f5e9e45b5a8db06fb90a6b5272ea2ff1fe86a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4636e8f586ca8f4aab67ac12636f5e9e45b5a8db06fb90a6b5272ea2ff1fe86a"
    sha256 cellar: :any_skip_relocation, sonoma:        "1b7d07d393dc0c4092ae3b725304902edc56a67f3af6c9d04443a5f76456af1f"
    sha256 cellar: :any_skip_relocation, ventura:       "1b7d07d393dc0c4092ae3b725304902edc56a67f3af6c9d04443a5f76456af1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4636e8f586ca8f4aab67ac12636f5e9e45b5a8db06fb90a6b5272ea2ff1fe86a"
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
