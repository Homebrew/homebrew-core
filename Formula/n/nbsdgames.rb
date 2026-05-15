class Nbsdgames < Formula
  desc "Text-based modern games"
  homepage "https://github.com/abakh/nbsdgames"
  url "https://github.com/abakh/nbsdgames/archive/refs/tags/v6.0.1.tar.gz"
  sha256 "7bbb45c9b65b5f7849582f06feff4d60e31cde13da9db7f344ca2eb69802491f"
  license :public_domain
  head "https://github.com/abakh/nbsdgames.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9e0bf3d3574bc4d7c6d51c388ea58f693f0fa43975942fecfa35d604b9db1ac2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7eab8ec09509503baa7dd39318a8940a6b3d544a289d23181c98c2f4a8dfe3a9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "13feaf28f72b3d999e1b7ce9d133ac6a32c597ea5c866930fd0de215de05212c"
    sha256 cellar: :any_skip_relocation, sonoma:        "7cdf5de0d0d574cb71f280980a063182ff9e5709cb2e42106cad5eb81ac3b17a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1196a093ea125de6fc19e7dd46a9e9e35e6dce7b9ea97ee7eeff97a4f6da6115"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd514bf4eda579c1f9dc5e42db6e1d7896ed65428cf4c6fa5ea8ac56419d0f45"
  end

  uses_from_macos "ncurses"

  def install
    mkdir bin
    system "make", "install",
           "GAMES_DIR=#{bin}",
           "SCORES_DIR=#{var}/games",
           "LIBS_PKG_CONFIG=-lncurses"

    man6.mkpath
    system "make", "manpages", "MAN_DIR=#{man6}"
  end

  test do
    assert_equal "2 <= size <= 7", shell_output("#{bin}/sudoku -s 1", 1).chomp
  end
end
