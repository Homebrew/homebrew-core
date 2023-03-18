class Arttime < Formula
  desc "Clock, timer, time manager and ASCII+ text-art viewer for the terminal"
  homepage "https://github.com/poetaman/arttime"
  url "https://github.com/poetaman/arttime/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "385c8ddf39653ab52c1c1ea8edca14c19cb3eb05c8d1e6627201ccb2cc191755"
  license "GPL-3.0-only"
  head "https://github.com/poetaman/arttime.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "57fab6fd2022c7a37b5f2b2480d869cdd65647e44f08a3c0c5d058022c77e498"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "57fab6fd2022c7a37b5f2b2480d869cdd65647e44f08a3c0c5d058022c77e498"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "57fab6fd2022c7a37b5f2b2480d869cdd65647e44f08a3c0c5d058022c77e498"
    sha256 cellar: :any_skip_relocation, ventura:        "336374db660ef5ebbce3f02192e1a38b450b3fca36b7420fec55c95f023109af"
    sha256 cellar: :any_skip_relocation, monterey:       "336374db660ef5ebbce3f02192e1a38b450b3fca36b7420fec55c95f023109af"
    sha256 cellar: :any_skip_relocation, big_sur:        "336374db660ef5ebbce3f02192e1a38b450b3fca36b7420fec55c95f023109af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "57fab6fd2022c7a37b5f2b2480d869cdd65647e44f08a3c0c5d058022c77e498"
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
