class Dungeon < Formula
  desc "the classic text adventure"
  homepage "https://github.com/GOFAI/dungeon"
  url "https://github.com/GOFAI/dungeon/archive/4.0.tar.gz"
  sha256 "be2217be9e23861f22c14c4395da272fca5fb08a1741f52fd393792908279bea"
  revision 1

  bottle do
    sha256 "1b7ad6df9083ccfe77ea44aa6c6c8018e2ac47cb642f41a38bcaccd5fd83b101" => :sierra
    sha256 "f8fa2ff30a4128014335dbcc653e5c4102b4803e0ae1a4b5b0dfda8e9f5dc141" => :el_capitan
    sha256 "fb1ca630a34b39361762e588bdd0273ffeb44fdc47912f5910927c77e7375164" => :yosemite
  end

  depends_on :fortran

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
      assert_equal " Welcome to Dungeon.\t\t\tThis version created 2-Dec-15.\n This is an open field west of a white house with a boarded front door.\n There is a small mailbox here.\n A rubber mat saying \"Welcome to Dungeon!\" lies by the door.\n > >", stdout.read
    end
  end
end
