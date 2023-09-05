class Nb < Formula
  desc "Command-line and local web note‑taking, bookmarking, and archiving"
  homepage "https://xwmx.github.io/nb"
  url "https://github.com/xwmx/nb/archive/refs/tags/7.5.9.tar.gz"
  sha256 "04d86c2a25397e3e5a33efac7a33b64d6e453553cf084db5451aaed245fb2164"
  license "AGPL-3.0-or-later"
  head "https://github.com/xwmx/nb.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1c1e5331d0efe3b840e522aff957c39e78d01e20109f96f879bcb336b1aac8ae"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1c1e5331d0efe3b840e522aff957c39e78d01e20109f96f879bcb336b1aac8ae"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1c1e5331d0efe3b840e522aff957c39e78d01e20109f96f879bcb336b1aac8ae"
    sha256 cellar: :any_skip_relocation, ventura:        "ac7bf0c7c34f6cce14f2dac2f6169389486544d45b9af73ac15617ccb8c2984b"
    sha256 cellar: :any_skip_relocation, monterey:       "ac7bf0c7c34f6cce14f2dac2f6169389486544d45b9af73ac15617ccb8c2984b"
    sha256 cellar: :any_skip_relocation, big_sur:        "ac7bf0c7c34f6cce14f2dac2f6169389486544d45b9af73ac15617ccb8c2984b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c1e5331d0efe3b840e522aff957c39e78d01e20109f96f879bcb336b1aac8ae"
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
