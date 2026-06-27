class Nbsdgames < Formula
  desc "Text-based modern games"
  homepage "https://github.com/abakh/nbsdgames"
  url "https://github.com/abakh/nbsdgames/archive/refs/tags/v6.0.2.tar.gz"
  sha256 "9545b099f6edb2be08d8885eaae2e10cf3d114c3a8fa1fc3eefff156053f37ca"
  license :public_domain
  head "https://github.com/abakh/nbsdgames.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cc0699404d93af0c48f6b09d79731ac55ac914f8882336c77a79bb569a9fd6fb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cab4bdbb4f81fcb81a6b36f2d4847f88f987069e6abb49ff566fa65f6ea6c540"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a72d596f76b58fb78d1d3a74d76a1b2c24da6f42f8092411a72f22670ada03d3"
    sha256 cellar: :any_skip_relocation, sonoma:        "ccc332edf5b6de3c7fa08f83713c9d7472b53c303b8233ecb1b4df7e17d12767"
    sha256 cellar: :any,                 arm64_linux:   "eca571daf08b41c07922289f8bfa32c155899dd47be0cd74dc9cdf3ad9ec8423"
    sha256 cellar: :any,                 x86_64_linux:  "df0af8ba58f6cca6262ffdb789cdf0582d5feee1dada287333fcbc8cce1a95f6"
  end

  depends_on "pkgconf" => :build

  uses_from_macos "ncurses"

  def install
    mkdir bin
    system "make", "install",
           "GAMES_DIR=#{bin}",
           "SCORES_DIR=#{var}/games",
           "MAN_DIR=#{man}",
           "LIBS_PKG_CONFIG=-lncurses"

    man6.mkpath
    system "make", "manpages", "MAN_DIR=#{man6}"
  end

  test do
    assert_equal "2 <= size <= 7", shell_output("#{bin}/sudoku -s 1", 1).chomp
  end
end
