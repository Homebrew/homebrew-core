class Arttime < Formula
  desc "Clock, timer, time manager and ASCII+ text-art viewer for the terminal"
  homepage "https://github.com/poetaman/arttime"
  url "https://github.com/poetaman/arttime/archive/refs/tags/v2.3.2.tar.gz"
  sha256 "e049a3d2a518bc7df318ac934420b00860489df810f3d1c655543b99ccc61edb"
  license "GPL-3.0-only"
  head "https://github.com/poetaman/arttime.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f9044e6f2a242cb2f6d0eb294f58110870ae7ad7ae30f27e66735bae3a7a536a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f9044e6f2a242cb2f6d0eb294f58110870ae7ad7ae30f27e66735bae3a7a536a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f9044e6f2a242cb2f6d0eb294f58110870ae7ad7ae30f27e66735bae3a7a536a"
    sha256 cellar: :any_skip_relocation, sonoma:         "1c8ed9b5f78d9955ecf0a7cda33b2fb6b38aefae736a7cd0a5fb711ccdc2de3a"
    sha256 cellar: :any_skip_relocation, ventura:        "1c8ed9b5f78d9955ecf0a7cda33b2fb6b38aefae736a7cd0a5fb711ccdc2de3a"
    sha256 cellar: :any_skip_relocation, monterey:       "1c8ed9b5f78d9955ecf0a7cda33b2fb6b38aefae736a7cd0a5fb711ccdc2de3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f9044e6f2a242cb2f6d0eb294f58110870ae7ad7ae30f27e66735bae3a7a536a"
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
