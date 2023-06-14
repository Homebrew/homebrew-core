class Nb < Formula
  desc "Command-line and local web note‑taking, bookmarking, and archiving"
  homepage "https://xwmx.github.io/nb"
  url "https://github.com/xwmx/nb/archive/refs/tags/7.5.2.tar.gz"
  sha256 "dc11bea344b47f51151aae9923c2cb5c76bbb7b474a1f8511be6c08aeb59d8af"
  license "AGPL-3.0-or-later"
  head "https://github.com/xwmx/nb.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f62c5291922752ccd66ca421fad63d27e6add7303e213b7f019dc56adaa9442d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f62c5291922752ccd66ca421fad63d27e6add7303e213b7f019dc56adaa9442d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f62c5291922752ccd66ca421fad63d27e6add7303e213b7f019dc56adaa9442d"
    sha256 cellar: :any_skip_relocation, ventura:        "97d1ff2cae07b9c68a7374bb914207d44a4fe8b070c8ef3680a7f70d0fbe7e29"
    sha256 cellar: :any_skip_relocation, monterey:       "97d1ff2cae07b9c68a7374bb914207d44a4fe8b070c8ef3680a7f70d0fbe7e29"
    sha256 cellar: :any_skip_relocation, big_sur:        "97d1ff2cae07b9c68a7374bb914207d44a4fe8b070c8ef3680a7f70d0fbe7e29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f62c5291922752ccd66ca421fad63d27e6add7303e213b7f019dc56adaa9442d"
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
