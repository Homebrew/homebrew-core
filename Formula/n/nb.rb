class Nb < Formula
  desc "Command-line and local web note-taking, bookmarking, and archiving"
  homepage "https://xwmx.github.io/nb"
  url "https://github.com/xwmx/nb/archive/refs/tags/7.19.1.tar.gz"
  sha256 "124ea1d390a16805cd1d3aed6797595c907a4a09e867ee6e36490bebe370e00f"
  license "AGPL-3.0-or-later"
  head "https://github.com/xwmx/nb.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3208591411264290fa2633fd21954edf3613e626eaf4b3a52e46eca533a4088b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3208591411264290fa2633fd21954edf3613e626eaf4b3a52e46eca533a4088b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3208591411264290fa2633fd21954edf3613e626eaf4b3a52e46eca533a4088b"
    sha256 cellar: :any_skip_relocation, sonoma:        "7f7aeb517abed3249f3bd69f415ccb3ca6de8492280ab60aab2268a099111907"
    sha256 cellar: :any_skip_relocation, ventura:       "7f7aeb517abed3249f3bd69f415ccb3ca6de8492280ab60aab2268a099111907"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3208591411264290fa2633fd21954edf3613e626eaf4b3a52e46eca533a4088b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3208591411264290fa2633fd21954edf3613e626eaf4b3a52e46eca533a4088b"
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

    bash_completion.install "etc/nb-completion.bash" => "nb"
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
