class Nb < Formula
  desc "Command-line and local web note-taking, bookmarking, and archiving"
  homepage "https://xwmx.github.io/nb"
  url "https://github.com/xwmx/nb/archive/refs/tags/7.16.1.tar.gz"
  sha256 "d173f20041ecf35f74ce1e559c78eb3c4ecf4bd790b44bacccc1769503164dd6"
  license "AGPL-3.0-or-later"
  head "https://github.com/xwmx/nb.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6b55071a7a344d4f6c6236c8ba515c5bbc32fa8ffbb9e42c4f4b8145f65e3b74"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6b55071a7a344d4f6c6236c8ba515c5bbc32fa8ffbb9e42c4f4b8145f65e3b74"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6b55071a7a344d4f6c6236c8ba515c5bbc32fa8ffbb9e42c4f4b8145f65e3b74"
    sha256 cellar: :any_skip_relocation, sonoma:        "c539dc237e2a0024a0691c00bcf297b73e2bad69674672fc01170986dd586e87"
    sha256 cellar: :any_skip_relocation, ventura:       "c539dc237e2a0024a0691c00bcf297b73e2bad69674672fc01170986dd586e87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6b55071a7a344d4f6c6236c8ba515c5bbc32fa8ffbb9e42c4f4b8145f65e3b74"
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
