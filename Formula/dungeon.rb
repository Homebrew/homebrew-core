class Dungeon < Formula
  desc "The classic text adventure"
  homepage "https://github.com/GOFAI/dungeon"
  url "https://github.com/GOFAI/dungeon/archive/4.0.tar.gz"
  sha256 "be2217be9e23861f22c14c4395da272fca5fb08a1741f52fd393792908279bea"
  revision 4

  bottle do
    cellar :any
    sha256 "f3430523323ddfc9c13f0040cfdb4ca2c89669c04abd9ff5beb224f34cb69273" => :catalina
    sha256 "cfac4e3fa4aa3c2e110bc59f6ebe90969b269a276e21a0e068ab645d3c72aae3" => :mojave
    sha256 "c2647f1348a819bd2ea493dc9655188cec00648aa897fc9d67211c7890e016b8" => :high_sierra
    sha256 "97f4cd4a4f424ca0469e34a0f0aa0c0a218c9d339c12160a749cb63f4ba4ce2d" => :sierra
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
