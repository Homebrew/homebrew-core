class Dateutils < Formula
  desc "Tools to manipulate dates with a focus on financial data"
  homepage "http://www.fresse.org/dateutils/"
  url "https://bitbucket.org/hroptatyr/dateutils/downloads/dateutils-0.4.0.tar.xz"
  mirror "https://github.com/hroptatyr/dateutils/releases/download/v0.4.0/dateutils-0.4.0.tar.xz"
  sha256 "d05af02bc60a82bdc21c0ac4779f1040f631b0a1233ed15c4f69a80d3dad23da"

  bottle do
    sha256 "53ef682e35b0de87fc1ecbc451c53af71720b8a3c13717e97b61dcd00dacc4fc" => :sierra
    sha256 "d22ff96e78940bd565a619948e67654ce62ab908e180fc367f21076a2c3260f6" => :el_capitan
    sha256 "6b08e887def30de21c576885787b7c7ebf5504aca47cb19e2d35d71ca83d6f4e" => :yosemite
    sha256 "dfcdd9ce7c86087cac280c8e58db98fccf6f7204492a8a678920875dea00e1d1" => :mavericks
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
