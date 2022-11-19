class Nb < Formula
  desc "Command-line and local web note‑taking, bookmarking, and archiving"
  homepage "https://xwmx.github.io/nb"
  url "https://github.com/xwmx/nb/archive/refs/tags/7.1.2.tar.gz"
  sha256 "d1fa4c4d08da0c26bb1b167b8308abbcfdfdeefb05432bcb236b17cb053ce6b5"
  license "AGPL-3.0-or-later"
  head "https://github.com/xwmx/nb.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8bdf43e4a720bd6538ae8dc60a43cac6f6c61fb98f229c10b9536b4c691ef355"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8bdf43e4a720bd6538ae8dc60a43cac6f6c61fb98f229c10b9536b4c691ef355"
    sha256 cellar: :any_skip_relocation, ventura:        "a8d0036da7ab1799f79b272537f28cd00e59935d90278c158439fec200dda390"
    sha256 cellar: :any_skip_relocation, monterey:       "a8d0036da7ab1799f79b272537f28cd00e59935d90278c158439fec200dda390"
    sha256 cellar: :any_skip_relocation, big_sur:        "a8d0036da7ab1799f79b272537f28cd00e59935d90278c158439fec200dda390"
    sha256 cellar: :any_skip_relocation, catalina:       "a8d0036da7ab1799f79b272537f28cd00e59935d90278c158439fec200dda390"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8bdf43e4a720bd6538ae8dc60a43cac6f6c61fb98f229c10b9536b4c691ef355"
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
