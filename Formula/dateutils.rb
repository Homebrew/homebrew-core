class Dateutils < Formula
  desc "Tools to manipulate dates with a focus on financial data"
  homepage "https://www.fresse.org/dateutils/"
  url "https://github.com/hroptatyr/dateutils/releases/download/v0.4.5/dateutils-0.4.5.tar.xz"
  sha256 "16d6a0fe7b7d49ddbb303f33538dd7304a0d4af5a0369bcbf275db6a5060cbde"

  bottle do
    sha256 "449a56bc74916687dc223db32a6c4c1b4a528b4ded8f25063f0d422f11e423ba" => :mojave
    sha256 "0bb1b166315c071b17e89cb7852ba1f53a320159ece30496657bfae759ddfb7a" => :high_sierra
    sha256 "53533c638c7dac539ca314e0e5a0b74f9aaa6129f152cc77a5fc722c128c0063" => :sierra
  end

  head do
    url "https://github.com/hroptatyr/dateutils.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
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
    output = shell_output("#{bin}/dconv 2012-03-04 -f \"%Y-%m-%c-%w\"").strip
    assert_equal "2012-03-01-00", output
  end
end
