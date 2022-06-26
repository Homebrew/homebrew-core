class Nb < Formula
  desc "Command-line and local web note‑taking, bookmarking, and archiving"
  homepage "https://xwmx.github.io/nb"
  url "https://github.com/xwmx/nb/archive/refs/tags/6.11.2.tar.gz"
  sha256 "a20550572f2af25647c3a3a858f80018fb64c0cb3d54627fb2708103d23fa2cd"
  license "AGPL-3.0-or-later"
  head "https://github.com/xwmx/nb.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "da16faa9f1367225d86a4e92705fbfef1ace28c9a897256d7cb13f06deb40b5f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "da16faa9f1367225d86a4e92705fbfef1ace28c9a897256d7cb13f06deb40b5f"
    sha256 cellar: :any_skip_relocation, monterey:       "1114f1f11aec2e5f7ee89f1949b09008e5d93a4e7cf02e35504ade6366c908d1"
    sha256 cellar: :any_skip_relocation, big_sur:        "1114f1f11aec2e5f7ee89f1949b09008e5d93a4e7cf02e35504ade6366c908d1"
    sha256 cellar: :any_skip_relocation, catalina:       "1114f1f11aec2e5f7ee89f1949b09008e5d93a4e7cf02e35504ade6366c908d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "da16faa9f1367225d86a4e92705fbfef1ace28c9a897256d7cb13f06deb40b5f"
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
