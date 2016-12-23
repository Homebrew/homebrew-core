class Dateutils < Formula
  desc "Tools to manipulate dates with a focus on financial data"
  homepage "http://www.fresse.org/dateutils/"
  url "https://bitbucket.org/hroptatyr/dateutils/downloads/dateutils-0.4.1.tar.xz"
  mirror "https://github.com/hroptatyr/dateutils/releases/download/v0.4.1/dateutils-0.4.1.tar.xz"
  sha256 "6ccce48975fc4d3af2e27c7893e181c46ab5df1cb37e4a428b4b521a77d55278"

  bottle do
    sha256 "12baf49c378b3e5f1f2c32aff5dd753d467290b3f531022824287733f8d8b0a3" => :sierra
    sha256 "d6a4966375bc9756aa188f1201fba14e4329e1a6b6957f9a50b6d9978df2a5ea" => :el_capitan
    sha256 "6c47012fd125727a10006fbadd0e42ee529102e9c6f6578b84942e437290bf70" => :yosemite
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
