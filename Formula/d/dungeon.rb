class Dungeon < Formula
  desc "Classic text adventure game"
  homepage "https://github.com/GOFAI/dungeon"
  url "https://github.com/GOFAI/dungeon/archive/refs/tags/4.1.tar.gz"
  sha256 "b88c49ef60e908e8611257fbb5a6a41860e1058760df2dfcb7eb141eb34e198b"
  license "HPND"
  revision 3

  no_autobump! because: :requires_manual_review

  bottle do
    sha256                               arm64_tahoe:    "f2275404ff5d7dc7bb33a0b5f90d2828faad83a4172b4678521fa6b248a99cee"
    sha256                               arm64_sequoia:  "d50cc1299d0c1d287a9528d49f0f93e2e208eb7cc6e766cab75a892063e2264f"
    sha256                               arm64_sonoma:   "465920dcc443e450f3043dbe316c10c57cd640393b1640fb4756f4acee9e72f1"
    sha256                               arm64_ventura:  "3c9c893622d3b9051d0c42929ecc64774e4bc9669a50cf2a088f32de229e05f2"
    sha256                               arm64_monterey: "7738a32ea7545be8c7bfa3e5c0deb5f675b34c89d72d352088cfe6e985673ea0"
    sha256                               arm64_big_sur:  "5a1bb16510c15a842aa9979c4d4c8655642b62959e46a857fdf68322a0967879"
    sha256 cellar: :any,                 sonoma:         "18130669bbc21c7b6ee6a51d7e751771588c95c92ddbab5d68b62ffcbe148c9d"
    sha256 cellar: :any,                 ventura:        "f1197055b9b31daea8f6e6cb9c28488a91c01c6a145604a18f6c077ef5e7c17d"
    sha256 cellar: :any,                 monterey:       "299d381405bcf4fe73087e2737812d12ad97dbc996e2015d3f666c0296660b23"
    sha256 cellar: :any,                 big_sur:        "c81b8009fb2183b96f6f0c45c4906a0048b535fb2d6abe7a82628e3c164a7375"
    sha256 cellar: :any,                 catalina:       "ddbf1a9789d9f3bfe42c91044f0296f3e67b87c272a8d7e435b2405da72c4219"
    sha256                               arm64_linux:    "641cccd8b42a81e9e30af8849bcde552d59b00c75fb45f88fb4842612be02b6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d67e7796b6a55b602bfd0112450b4fffee2c640599fc380dedbf4108d090877d"
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
    Open3.popen3(bin/"dungeon") do |stdin, stdout, _|
      stdin.close
      assert_match " Welcome to Dungeon.\t\t\t", stdout.read
    end
  end
end
