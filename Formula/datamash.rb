class Datamash < Formula
  desc "Tool to perform numerical, textual & statistical operations"
  homepage "https://www.gnu.org/software/datamash"
  url "https://ftpmirror.gnu.org/datamash/datamash-1.1.1.tar.gz"
  mirror "https://ftp.gnu.org/gnu/datamash/datamash-1.1.1.tar.gz"
  sha256 "420819b3d7372ee3ce704add847cff7d08c4f8176c1d48735d4a632410bb801b"

  head do
    url "git://git.savannah.gnu.org/datamash.git"
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
