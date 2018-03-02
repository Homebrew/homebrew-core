class Dateutils < Formula
  desc "Tools to manipulate dates with a focus on financial data"
  homepage "https://www.fresse.org/dateutils/"
  url "https://bitbucket.org/hroptatyr/dateutils/downloads/dateutils-0.4.3.tar.xz"
  sha256 "b0d579062bc957823fb7efcb2c520fb6fb43ab79a352026402b06ecfc4c58f1a"

  bottle do
    sha256 "e9ba9bee465b5a7b062a978ad8a99aa8e157624da61ac2340b38a8faa6eb8955" => :high_sierra
    sha256 "2dcf7fe928ca66452ee3ecdf6c65fa9d0fb9ea52c8d3c05f96efc335f63a968f" => :sierra
    sha256 "76e159e564a5f00a6421b43306223fc84c40c77c5e3b4938372c6c1835d38b05" => :el_capitan
    sha256 "e4d2ff409bc632cd21d3dd1693a58cd4c1008583783856ef73baef074c3441a8" => :yosemite
  end

  head do
    url "https://github.com/hroptatyr/dateutils.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  def install
    system "autoreconf", "-iv" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_equal "2012-03-01-00", shell_output("#{bin}/dconv 2012-03-04 -f \"%Y-%m-%c-%w\"").strip
  end
end
