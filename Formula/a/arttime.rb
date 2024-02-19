class Arttime < Formula
  desc "Clock, timer, time manager and ASCII+ text-art viewer for the terminal"
  homepage "https://github.com/poetaman/arttime"
  url "https://github.com/poetaman/arttime/archive/refs/tags/v2.3.0.tar.gz"
  sha256 "67a750e7c92c3fb632155c510a3ad4a1eb802d14f984fb0dc832505db6072b3a"
  license "GPL-3.0-only"
  head "https://github.com/poetaman/arttime.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d54dff576546f78262c3312672f4e2702c3815da90602d91364ffb5d8ab42df3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d54dff576546f78262c3312672f4e2702c3815da90602d91364ffb5d8ab42df3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d54dff576546f78262c3312672f4e2702c3815da90602d91364ffb5d8ab42df3"
    sha256 cellar: :any_skip_relocation, sonoma:         "06401c648aeacb02bb22ea2203afb3cd8245829580c44f988025dc1f704e96ca"
    sha256 cellar: :any_skip_relocation, ventura:        "06401c648aeacb02bb22ea2203afb3cd8245829580c44f988025dc1f704e96ca"
    sha256 cellar: :any_skip_relocation, monterey:       "06401c648aeacb02bb22ea2203afb3cd8245829580c44f988025dc1f704e96ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d54dff576546f78262c3312672f4e2702c3815da90602d91364ffb5d8ab42df3"
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
