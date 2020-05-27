class Dungeon < Formula
  desc "The classic text adventure"
  homepage "https://github.com/GOFAI/dungeon"
  url "https://github.com/GOFAI/dungeon/archive/4.1.tar.gz"
  sha256 "b88c49ef60e908e8611257fbb5a6a41860e1058760df2dfcb7eb141eb34e198b"

  bottle do
    cellar :any
    sha256 "e6053a32332a47c67f278eb771d660e765ff2fdbd4e25f5de71eb8ad429ab482" => :catalina
    sha256 "5e78dda1bcf691d43008ae18a8013a46d8c8f4cf59e0801b7fd98577f5204c7c" => :mojave
    sha256 "1b5ee6cef285b8c96baa060a2d4ea3c55e42a8ad2afd0cfd7f9f776d7f358cba" => :high_sierra
  end

  depends_on "gcc" # for gfortran

  def install
    chdir "src" do
      # look for game files where homebrew installed them, not pwd
      inreplace "game.f" do |s|
        s.gsub! "FILE='dindx',STATUS='OLD',", "FILE='#{opt_pkgshare}/dindx',"
        s.gsub! "1\tFORM='FORMATTED',ACCESS='SEQUENTIAL',ERR=1900)", "1\tSTATUS='OLD',FORM='FORMATTED',
\t2\tACCESS='SEQUENTIAL',ERR=1900)"
        s.gsub! "FILE='dtext',STATUS='OLD',", "FILE='#{opt_pkgshare}/dtext',"
        s.gsub! "1\tFORM='UNFORMATTED',ACCESS='DIRECT',", "1\tSTATUS='OLD',FORM='UNFORMATTED',ACCESS='DIRECT',"
      end
      system "make"
      bin.install "dungeon"
    end
    pkgshare.install "dindx"
    pkgshare.install "dtext"
    man.install "dungeon.txt"
    man.install "hints.txt"
  end

  test do
    require "open3"
    Open3.popen3("#{bin}/dungeon") do |stdin, stdout, _|
      stdin.close
      assert_match " Welcome to Dungeon.\t\t\t", stdout.read
    end
  end
end
