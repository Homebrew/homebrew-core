class Nb < Formula
  desc "Command-line and local web note-taking, bookmarking, and archiving"
  homepage "https://xwmx.github.io/nb"
  url "https://github.com/xwmx/nb/archive/refs/tags/7.9.1.tar.gz"
  sha256 "9d16d886feac16a99aaa6b3c2a7d327e6f3b3c96b4d4213c17b03350e579630a"
  license "AGPL-3.0-or-later"
  head "https://github.com/xwmx/nb.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4be888126d1db5a66f4de2890a021ea5db570a79e859ab1791f6045f913de55a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4be888126d1db5a66f4de2890a021ea5db570a79e859ab1791f6045f913de55a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4be888126d1db5a66f4de2890a021ea5db570a79e859ab1791f6045f913de55a"
    sha256 cellar: :any_skip_relocation, sonoma:         "3e0321e62ca6d3f7c9113ca988c5dd9973e62362a14e54acbd09facde0916210"
    sha256 cellar: :any_skip_relocation, ventura:        "3e0321e62ca6d3f7c9113ca988c5dd9973e62362a14e54acbd09facde0916210"
    sha256 cellar: :any_skip_relocation, monterey:       "3e0321e62ca6d3f7c9113ca988c5dd9973e62362a14e54acbd09facde0916210"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4be888126d1db5a66f4de2890a021ea5db570a79e859ab1791f6045f913de55a"
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
