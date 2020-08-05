class Datamash < Formula
  desc "Tool to perform numerical, textual & statistical operations"
  homepage "https://www.gnu.org/software/datamash"
  url "https://ftp.gnu.org/gnu/datamash/datamash-1.7.tar.gz"
  mirror "https://ftpmirror.gnu.org/datamash/datamash-1.7.tar.gz"
  sha256 "574a592bb90c5ae702ffaed1b59498d5e3e7466a8abf8530c5f2f3f11fa4adb3"

  bottle do
    cellar :any_skip_relocation
    sha256 "f592c4bda737ef924fb4c1642fb381db54c9ce246eb51d03a145dd28a8391406" => :catalina
    sha256 "6533f0decc607d6e3ce1ad1fdb7f5b30f99bbbcbacbba1bcd880486eef648189" => :mojave
    sha256 "b6100d066c3cf9d91b2bd4a8d8bcdc5fa453c6eb6a28d7cacb06659baa358e46" => :high_sierra
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
