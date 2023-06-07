class Arttime < Formula
  desc "Clock, timer, time manager and ASCII+ text-art viewer for the terminal"
  homepage "https://github.com/poetaman/arttime"
  url "https://github.com/poetaman/arttime/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "14be3e59e327dd4f0dd4d41cedbdbb3ba31b9df3b7a414895cbaf2a9f636baca"
  license "GPL-3.0-only"
  head "https://github.com/poetaman/arttime.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5f01b76f9d08e8e6a80d4bb1924be5308f119792253a1939000427c428ce1993"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5f01b76f9d08e8e6a80d4bb1924be5308f119792253a1939000427c428ce1993"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5f01b76f9d08e8e6a80d4bb1924be5308f119792253a1939000427c428ce1993"
    sha256 cellar: :any_skip_relocation, ventura:        "1bbbb67e6d6a8825b973166cd47be7dad207f059704d875ce31f5633e5c61794"
    sha256 cellar: :any_skip_relocation, monterey:       "1bbbb67e6d6a8825b973166cd47be7dad207f059704d875ce31f5633e5c61794"
    sha256 cellar: :any_skip_relocation, big_sur:        "1bbbb67e6d6a8825b973166cd47be7dad207f059704d875ce31f5633e5c61794"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5f01b76f9d08e8e6a80d4bb1924be5308f119792253a1939000427c428ce1993"
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
