class Hexcurse < Formula
  desc "Ncurses-based console hex editor"
  homepage "https://github.com/LonnyGomes/hexcurse"
  url "https://github.com/LonnyGomes/hexcurse/archive/v1.60.0.tar.gz"
  sha256 "f6919e4a824ee354f003f0c42e4c4cef98a93aa7e3aa449caedd13f9a2db5530"
  license "LGPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c5778ff4ddb2d3d4d18c4150c34d2a73be472c239a81a243dd03f93a494a4fcb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5147e2ba447a362995e7b4de49fa9519c7f4f4a72e00396e1e850ebc5e6d6e30"
    sha256 cellar: :any_skip_relocation, monterey:       "7af11f5ed0d454f43e40d39f35fb1967414d81f314aa46fbadd556265c0966e3"
    sha256 cellar: :any_skip_relocation, big_sur:        "26bbc403b9590ad6891663edfb0c424c7497755098873e4f5cc95fb7231e259b"
    sha256 cellar: :any_skip_relocation, catalina:       "977632cc06d33a8d2f7f44866a7497dc7f8b8b423869f348827f20811c024935"
    sha256 cellar: :any_skip_relocation, mojave:         "1e940f63d87629fd0fd6758436679eac6238afae871681c5d65e03cfce11bde1"
    sha256 cellar: :any_skip_relocation, high_sierra:    "071ab88d401cc9ff24c6d466f291217d57082d07649ddb39f7d6aa28dd9ed7e6"
    sha256 cellar: :any_skip_relocation, sierra:         "580efaffc5d8dccb0f4f6532ad5be35e372c6b8d91dfb6d3930aa773c9bf7ea1"
    sha256 cellar: :any_skip_relocation, el_capitan:     "ffe690a87522627dc0088c391f7237fc6a3f2aa12fc5a3487c0aa6694905dc4d"
    sha256 cellar: :any_skip_relocation, yosemite:       "ef5644e4e96604f6f3bbe802e7824a7fd82e01163d532d0e2be6a93cc6595eab"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    system "#{bin}/hexcurse", "-help"
  end
end
