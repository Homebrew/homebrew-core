class Nb < Formula
  desc "Command-line and local web note‑taking, bookmarking, and archiving"
  homepage "https://xwmx.github.io/nb"
  url "https://github.com/xwmx/nb/archive/refs/tags/7.1.1.tar.gz"
  sha256 "45ce1481771711fd31e63928f9e770caae5896ff59e9133d545e107c99252197"
  license "AGPL-3.0-or-later"
  head "https://github.com/xwmx/nb.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "545fb520a231889c8851da1334279224f30ffab9e4358827b029fd1339aca2e8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "545fb520a231889c8851da1334279224f30ffab9e4358827b029fd1339aca2e8"
    sha256 cellar: :any_skip_relocation, monterey:       "8f2dcd9c86345e890a2d53c80fc73df277503917e6f192edcb9332bdf5a5e64a"
    sha256 cellar: :any_skip_relocation, big_sur:        "8f2dcd9c86345e890a2d53c80fc73df277503917e6f192edcb9332bdf5a5e64a"
    sha256 cellar: :any_skip_relocation, catalina:       "8f2dcd9c86345e890a2d53c80fc73df277503917e6f192edcb9332bdf5a5e64a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "545fb520a231889c8851da1334279224f30ffab9e4358827b029fd1339aca2e8"
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
