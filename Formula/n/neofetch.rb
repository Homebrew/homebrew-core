class Neofetch < Formula
  desc "Fast, highly customisable system info script"
  homepage "https://github.com/dylanaraps/neofetch"
  url "https://github.com/dylanaraps/neofetch/archive/refs/tags/7.1.0.tar.gz"
  sha256 "58a95e6b714e41efc804eca389a223309169b2def35e57fa934482a6b47c27e7"
  license "MIT"
  head "https://github.com/dylanaraps/neofetch.git", branch: "master"

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d1a2a14e36d3beb1d907cca877438c031857df97d42916334e93b1fd426a3d4e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d1a2a14e36d3beb1d907cca877438c031857df97d42916334e93b1fd426a3d4e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d1a2a14e36d3beb1d907cca877438c031857df97d42916334e93b1fd426a3d4e"
    sha256 cellar: :any_skip_relocation, sonoma:         "d1a2a14e36d3beb1d907cca877438c031857df97d42916334e93b1fd426a3d4e"
    sha256 cellar: :any_skip_relocation, ventura:        "d1a2a14e36d3beb1d907cca877438c031857df97d42916334e93b1fd426a3d4e"
    sha256 cellar: :any_skip_relocation, monterey:       "d1a2a14e36d3beb1d907cca877438c031857df97d42916334e93b1fd426a3d4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2fdb0500241669f3f5ede2f5a6bd8b2fc683e6f4f01e1ad39c09d2df7395259b"
  end

  deprecate! date: "2024-05-04", because: :repo_archived

  on_macos do
    depends_on "screenresolution"
  end

  def install
    inreplace "neofetch", "/usr/local", HOMEBREW_PREFIX
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system bin/"neofetch", "--config", "none", "--color_blocks", "off",
                              "--disable", "wm", "de", "term", "gpu"
  end
end
