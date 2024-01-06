class Arttime < Formula
  desc "Clock, timer, time manager and ASCII+ text-art viewer for the terminal"
  homepage "https://github.com/poetaman/arttime"
  url "https://github.com/poetaman/arttime/archive/refs/tags/v2.1.3.tar.gz"
  sha256 "eb5ffaea82e39e47f0017b690ba8337a43a36437a5b2cf86f0fb0e795f01d4d4"
  license "GPL-3.0-only"
  head "https://github.com/poetaman/arttime.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0ce4701467f25a4360da345e7f9706f9491e065a6d568567d0dc37f3ff0aedfd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0ce4701467f25a4360da345e7f9706f9491e065a6d568567d0dc37f3ff0aedfd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0ce4701467f25a4360da345e7f9706f9491e065a6d568567d0dc37f3ff0aedfd"
    sha256 cellar: :any_skip_relocation, sonoma:         "430f746cb4a8eb12c3e5022a9713061ab000ce7153a14aa71b65c0617408099e"
    sha256 cellar: :any_skip_relocation, ventura:        "430f746cb4a8eb12c3e5022a9713061ab000ce7153a14aa71b65c0617408099e"
    sha256 cellar: :any_skip_relocation, monterey:       "430f746cb4a8eb12c3e5022a9713061ab000ce7153a14aa71b65c0617408099e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ce4701467f25a4360da345e7f9706f9491e065a6d568567d0dc37f3ff0aedfd"
  end

  depends_on "fzf"

  on_linux do
    depends_on "diffutils"
    depends_on "less"
    depends_on "libnotify"
    depends_on "vorbis-tools"
    depends_on "zsh"
  end

  def install
    ENV["TERM"]="xterm"
    system "./install.sh", "--noupdaterc", "--prefix", prefix, "--zcompdir", zsh_completion
  end

  def caveats
    on_macos do
      <<~EOS
        Notification settings on macOS are not fully in control of an application.
        To check if you have desired notification settings, open following link:
          https://github.com/poetaman/arttime/issues/11
      EOS
    end
  end

  test do
    # arttime is a GUI application
    system bin/"arttime", "--version"
  end
end
