class Datamash < Formula
  desc "Tool to perform numerical, textual & statistical operations"
  homepage "https://www.gnu.org/software/datamash"
  url "https://ftp.gnu.org/gnu/datamash/datamash-1.6.tar.gz"
  mirror "https://ftpmirror.gnu.org/datamash/datamash-1.6.tar.gz"
  sha256 "b9b9b79399616bb54722edbbcaa84303801eb62a338b3a20b6f029003deb78cb"

  bottle do
    cellar :any_skip_relocation
    sha256 "3e742a1c733808b937064edaeb265f7e2646b9e6ca1ddf69fbf55ef2f6fd40d7" => :catalina
    sha256 "dac6b5134854f898d0e5c7eb1bedf21ccd1d9844d4cca17251c3f7bdc97248bd" => :mojave
    sha256 "8b460389cbdda7c0e33d3b34531a88ef9a1311415fcffef40aed15c87c6fa9c7" => :high_sierra
  end

  head do
    url "https://git.savannah.gnu.org/git/datamash.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
  end

  def install
    system "./bootstrap" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_equal "55", shell_output("seq 10 | #{bin}/datamash sum 1").chomp
  end
end
