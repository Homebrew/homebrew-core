class Nb < Formula
  desc "Command-line and local web note‑taking, bookmarking, and archiving"
  homepage "https://xwmx.github.io/nb"
  url "https://github.com/xwmx/nb/archive/refs/tags/7.7.0.tar.gz"
  sha256 "3142c4876a7d75c3f554ed3a31ee825b08e3cb785e7f718f503c853f9d10f75c"
  license "AGPL-3.0-or-later"
  head "https://github.com/xwmx/nb.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c7730c96c6e07cc21cb87e9ec9d337d229b7963b9faf83b65149ca0c40448abe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c7730c96c6e07cc21cb87e9ec9d337d229b7963b9faf83b65149ca0c40448abe"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c7730c96c6e07cc21cb87e9ec9d337d229b7963b9faf83b65149ca0c40448abe"
    sha256 cellar: :any_skip_relocation, ventura:        "a5fcf5da1190bc29addee9dbd1bff8e5b5354ce14c72d7a30ae72386b970ee1e"
    sha256 cellar: :any_skip_relocation, monterey:       "a5fcf5da1190bc29addee9dbd1bff8e5b5354ce14c72d7a30ae72386b970ee1e"
    sha256 cellar: :any_skip_relocation, big_sur:        "a5fcf5da1190bc29addee9dbd1bff8e5b5354ce14c72d7a30ae72386b970ee1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c7730c96c6e07cc21cb87e9ec9d337d229b7963b9faf83b65149ca0c40448abe"
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
