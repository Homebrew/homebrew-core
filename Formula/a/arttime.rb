class Arttime < Formula
  desc "Clock, timer, time manager and ASCII+ text-art viewer for the terminal"
  homepage "https://github.com/poetaman/arttime"
  url "https://github.com/poetaman/arttime/archive/refs/tags/v2.1.2.tar.gz"
  sha256 "47f02b21f7a11dc636f3f34d11f35c149e0ead50b0919ed9e49a3c1d6c99b66f"
  license "GPL-3.0-only"
  head "https://github.com/poetaman/arttime.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c5d309c831925d401479b04cdccd88530cdba91b23b9292353c6e3de11f4b182"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c5d309c831925d401479b04cdccd88530cdba91b23b9292353c6e3de11f4b182"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c5d309c831925d401479b04cdccd88530cdba91b23b9292353c6e3de11f4b182"
    sha256 cellar: :any_skip_relocation, ventura:        "07d0b49a1347fe00fd2cef1a8477b3d7e96f6e5aeefd5f8d742a65962ebf2326"
    sha256 cellar: :any_skip_relocation, monterey:       "07d0b49a1347fe00fd2cef1a8477b3d7e96f6e5aeefd5f8d742a65962ebf2326"
    sha256 cellar: :any_skip_relocation, big_sur:        "07d0b49a1347fe00fd2cef1a8477b3d7e96f6e5aeefd5f8d742a65962ebf2326"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c5d309c831925d401479b04cdccd88530cdba91b23b9292353c6e3de11f4b182"
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

  test do
    # arttime is a GUI application
    system bin/"arttime", "--version"
  end
end
