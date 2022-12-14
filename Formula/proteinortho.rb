class Proteinortho < Formula
  desc "Detecting orthologous genes within different species"
  homepage "https://gitlab.com/paulklemm_PHD/proteinortho"
  url "https://gitlab.com/paulklemm_PHD/proteinortho/-/archive/v6.1.6/proteinortho-v6.1.6.tar.gz"
  sha256 "a533817ce99ce471bce567974090a44a5281055c3aef18e90cb4425d5a877e85"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "723c844cf90ff27b0971d802f3c55bbf7e4600dc4139581db590ca04369b3e00"
    sha256 cellar: :any,                 arm64_monterey: "9444ac857148f2f72faeefb4db23ad78c1cd85e91a17782abd68ef7dce8df640"
    sha256 cellar: :any,                 arm64_big_sur:  "49ef58ef5ca0b8883740bb64a7a908ac61dd3ece17bf96bed7b1b089d417a517"
    sha256 cellar: :any,                 ventura:        "81906bbfacf0b35f1de685ec623876e52e535c76047402fbd459af79c35e1774"
    sha256 cellar: :any,                 monterey:       "cfa570a4a528a007840fffee9a996f6ab203fa88c5a245528138e91bd5e3db4b"
    sha256 cellar: :any,                 big_sur:        "ca69cd32603ac5dbdd1309235ecc3033bf7d2b9022d8328d01754eeb68a7f253"
    sha256 cellar: :any,                 catalina:       "8732e9696cac961b92f0e9e747b3f8332cf4484e2aa376af221a48f4d6f4a1cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f2c9241deb186555e21db7a02b92dd7fa764eee761d8162d3262ddd2da7e8a83"
  end

  depends_on "diamond"
  depends_on "openblas"

  def install
    ENV.cxx11

    bin.mkpath
    system "make", "install", "PREFIX=#{bin}"
    doc.install "manual.html"
  end

  test do
    system "#{bin}/proteinortho", "-test"
    system "#{bin}/proteinortho_clustering", "-test"
  end
end
