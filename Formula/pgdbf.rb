class Pgdbf < Formula
  desc "Converter of XBase/FoxPro tables to PostgreSQL"
  homepage "https://github.com/kstrauser/pgdbf"
  url "https://downloads.sourceforge.net/project/pgdbf/pgdbf/0.6.2/pgdbf-0.6.2.tar.xz"
  sha256 "e46f75e9ac5f500bd12c4542b215ea09f4ebee638d41dcfd642be8e9769aa324"
  license "GPL-3.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c2ecba3b5b9e4803f45f71afbaf66d85333ec329f74513123dbfdc9822b803c6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2743386480c1d76708d184813b77daadec3bc7a70a542647308c9fb414aa65e3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b51760692708d6b3926a405f7b2e83553feeea062a1af91aa0b15858cf9e8b8c"
    sha256 cellar: :any_skip_relocation, ventura:        "30721323815b2ff787ea33a99a3a693e126eb4f3222c447a59c8b10d3fa677ba"
    sha256 cellar: :any_skip_relocation, monterey:       "6381607bca777a7beb5d475f656a949e580e82b15d1f63fa109764c652da5d9c"
    sha256 cellar: :any_skip_relocation, big_sur:        "efd6ad07c77d7c973b9d4bd8e13ea837b43ac281c817f3ce300ac6c46de3f2e4"
    sha256 cellar: :any_skip_relocation, catalina:       "ae8050a5d6a6f91f529a0985a5626981d22573094791274c7bc1759b2770c4c7"
    sha256 cellar: :any_skip_relocation, mojave:         "4a76ca05c6b73ea6fcf57d6699cbaf3e249c5e3b20990e51ab33d11bfbdd7d50"
    sha256 cellar: :any_skip_relocation, high_sierra:    "caf544eee09339bb34ab68a35880bc863bb13aa7943de98ef25680cb0182f901"
    sha256 cellar: :any_skip_relocation, sierra:         "7d0eabf3051e9cf450d985987f89cf0d70476b37202b3b5bdc84ec48e8cb670d"
    sha256 cellar: :any_skip_relocation, el_capitan:     "72ad6b801d25db2008d0ab4badd2bb280f55eb6f6956925ee5620d62d8f06bbb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7f2e231fc1b78b7837dfe257a04e2495128237e5800609675573dd2734185ea5"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
