class Nbsdgames < Formula
  desc "Text-based modern games"
  homepage "https://github.com/abakh/nbsdgames"
  url "https://github.com/abakh/nbsdgames/archive/refs/tags/v6.0.3.tar.gz"
  sha256 "359da5f698da00437205eddad3fc97fbdcecfa8cb005fd8d1830fe8fd3dd7e3b"
  license :public_domain
  head "https://github.com/abakh/nbsdgames.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "fd6fca94d9b6453aa53c82ec09481ff0866928a3a58296fe4a2b3685158f67c0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d5783c6f1e6757142771a262c3b4624987dd6ac1ec90936f8fa19f2f40e8a240"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "08b079def0fb3bc076824e2f7cdd234de230b353c11fbea44377aa91bdf1dd37"
    sha256 cellar: :any,                 arm64_linux:       "b4174a183b18c2cd280248bf9c51fe79eb17dbbf97c44a2d1bd27a47c21ea3d6"
    sha256 cellar: :any,                 x86_64_linux:      "8567cd11e80c38c936b9163c6535beb9b278130866c48e8265b27b3fe127ae40"
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
