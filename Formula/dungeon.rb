class Dungeon < Formula
  desc "Classic text adventure game"
  homepage "https://github.com/GOFAI/dungeon"
  url "https://github.com/GOFAI/dungeon/archive/4.1.tar.gz"
  sha256 "b88c49ef60e908e8611257fbb5a6a41860e1058760df2dfcb7eb141eb34e198b"
  license "HPND"
  revision 2

  bottle do
    rebuild 1
    sha256                               arm64_monterey: "7b1e99eb8093ed7abf3f8675d73f3a2037a3f290a12940d6075708f161ea86c5"
    sha256                               arm64_big_sur:  "7486b92b9095713ce8b13ffd23975859f87e0aabd41a25d54d7b888e76229eb9"
    sha256 cellar: :any,                 monterey:       "453e0f5f0226b78ff6ed0d07181b829839a72100cc06f3f061660a7844c8fe22"
    sha256 cellar: :any,                 big_sur:        "0abe715ad699601ac7c7452ae0cf5919db535f8402e01e8ed9de9e4ec18c7622"
    sha256 cellar: :any,                 catalina:       "c6d5bc787bba88658003a4e7bd1fd56c0fbdf485468dd30f41566f06fba56a64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff530460a2ad3a514894694f78a30e60b2f3683b28f35dd4b61feb055a8343f7"
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
      inreplace "Makefile" do |s|
        s.gsub! "gfortran -g", "gfortran -ffixed-line-length-none -g"
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
