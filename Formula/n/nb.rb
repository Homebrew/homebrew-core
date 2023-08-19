class Nb < Formula
  desc "Command-line and local web note‑taking, bookmarking, and archiving"
  homepage "https://xwmx.github.io/nb"
  url "https://github.com/xwmx/nb/archive/refs/tags/7.5.7.tar.gz"
  sha256 "bcb3d3f6c81a6638b39f82ba5a6142d17f94085ee70c475623fb4e646642cd0d"
  license "AGPL-3.0-or-later"
  head "https://github.com/xwmx/nb.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "baf08dda9c9eb5b3b7fa98d84c9661f1555c15305f5979c5877292190387f419"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "baf08dda9c9eb5b3b7fa98d84c9661f1555c15305f5979c5877292190387f419"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "baf08dda9c9eb5b3b7fa98d84c9661f1555c15305f5979c5877292190387f419"
    sha256 cellar: :any_skip_relocation, ventura:        "187681e6da26249753631619e8be43713ae97e814e799d273d5746f44edf3011"
    sha256 cellar: :any_skip_relocation, monterey:       "187681e6da26249753631619e8be43713ae97e814e799d273d5746f44edf3011"
    sha256 cellar: :any_skip_relocation, big_sur:        "187681e6da26249753631619e8be43713ae97e814e799d273d5746f44edf3011"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "baf08dda9c9eb5b3b7fa98d84c9661f1555c15305f5979c5877292190387f419"
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
