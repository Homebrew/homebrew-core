class Dungeon < Formula
  desc "Classic text adventure game"
  homepage "https://github.com/GOFAI/dungeon"
  url "https://github.com/GOFAI/dungeon/archive/4.1.tar.gz"
  sha256 "b88c49ef60e908e8611257fbb5a6a41860e1058760df2dfcb7eb141eb34e198b"
  revision 2

  bottle do
    sha256 cellar: :any, monterey: "0006884c95751a0b5075a416e73d7082c5c7d458df79eac1f486aecd42aab6ec"
    sha256 cellar: :any, big_sur:  "23739a563a06cb0d42b43fd034b423cd9218ec99919c4ac1bb0869d71f1bf89a"
    sha256 cellar: :any, catalina: "aa2177395fa3363eb9bc0de0de2da7d93ac3b78b5ce86c14daff6f19c69a9e4f"
    sha256 cellar: :any, mojave:   "f5dd94642da0883ada9e1ac9f93e91a0c47b02b48226d2318be67028b97402f9"
  end

  depends_on "gcc" # for gfortran

  def install
    chdir "src" do
      # look for game files where homebrew installed them, not pwd
      inreplace "game.f" do |s|
        s.gsub! "FILE='dindx',STATUS='OLD',", "FILE='#{opt_pkgshare}/dindx',"
        s.gsub! "1\tFORM='FORMATTED',ACCESS='SEQUENTIAL',ERR=1900)", "1\tSTATUS='OLD',FORM='FORMATTED'," \
                                                                     "\n\t2\tACCESS='SEQUENTIAL',ERR=1900)"
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
