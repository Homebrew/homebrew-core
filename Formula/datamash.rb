class Datamash < Formula
  desc "Tool to perform numerical, textual & statistical operations"
  homepage "https://www.gnu.org/software/datamash"
  url "https://ftp.gnu.org/gnu/datamash/datamash-1.3.tar.gz"
  mirror "https://ftpmirror.gnu.org/datamash/datamash-1.3.tar.gz"
  sha256 "eebb52171a4353aaad01921384098cf54eb96ebfaf99660e017f6d9fc96657a6"

  bottle do
    cellar :any_skip_relocation
    sha256 "f80a0f35f13dc924a42977fd5d3b69e871ff17a51e7d91ffef93ffc1fe33e37e" => :high_sierra
    sha256 "b0eaec94032f69086bbbdcc7d38a59d7f03ba9511a8ce47a965fcf9e18229cb6" => :sierra
    sha256 "d310a35d4ad9760fb4b936429f453b30baf6c5d474983c3928344f8dca145283" => :el_capitan
    sha256 "cf022df27f4f7cf13b171e84d05816e8eddbae6c0190b0e339b269178d935ada" => :yosemite
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
