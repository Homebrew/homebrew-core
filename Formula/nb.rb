class Nb < Formula
  desc "Command-line and local web note‑taking, bookmarking, and archiving"
  homepage "https://xwmx.github.io/nb"
  url "https://github.com/xwmx/nb/archive/refs/tags/7.2.1.tar.gz"
  sha256 "6b3096b3d5d6ba754a7d67095136453611c59249575a90ef635017c8bc5ff0fa"
  license "AGPL-3.0-or-later"
  head "https://github.com/xwmx/nb.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1bb6184b4c07b58dc7e51b76c6f6d77a249c4c356c411bd11a195d74a86bfb98"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1bb6184b4c07b58dc7e51b76c6f6d77a249c4c356c411bd11a195d74a86bfb98"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1bb6184b4c07b58dc7e51b76c6f6d77a249c4c356c411bd11a195d74a86bfb98"
    sha256 cellar: :any_skip_relocation, ventura:        "528e9d86c4bd78a135de4d9dbe4a2c2c51eba8bda05f9ac3e384b315d8078d90"
    sha256 cellar: :any_skip_relocation, monterey:       "528e9d86c4bd78a135de4d9dbe4a2c2c51eba8bda05f9ac3e384b315d8078d90"
    sha256 cellar: :any_skip_relocation, big_sur:        "528e9d86c4bd78a135de4d9dbe4a2c2c51eba8bda05f9ac3e384b315d8078d90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1bb6184b4c07b58dc7e51b76c6f6d77a249c4c356c411bd11a195d74a86bfb98"
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
