class Dungeon < Formula
  desc "The classic text adventure"
  homepage "https://github.com/GOFAI/dungeon"
  url "https://github.com/GOFAI/dungeon/archive/4.0.tar.gz"
  sha256 "be2217be9e23861f22c14c4395da272fca5fb08a1741f52fd393792908279bea"
  revision 2

  bottle do
    sha256 "e0252a20faaee35aa1768a3f7a31441de5d73028bd722419f632cc66bb92d22b" => :high_sierra
    sha256 "18af74d676dbc99acfa51088bbcf89dd4c80f89290bc25b4ca030ae23ad82c01" => :sierra
    sha256 "7e293839e0e151c0bb20423f8bdad447d2b31c905737359c7a47cb296f223816" => :el_capitan
    sha256 "6177df6d7568967456aad92c0b1e55c45eab0c91e4d88d25ad76ff90d9704fda" => :yosemite
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
