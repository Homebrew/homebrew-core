class Dateutils < Formula
  desc "Tools to manipulate dates with a focus on financial data"
  homepage "http://www.fresse.org/dateutils/"
  url "https://bitbucket.org/hroptatyr/dateutils/downloads/dateutils-0.4.2.tar.xz"
  mirror "https://github.com/hroptatyr/dateutils/releases/download/v0.4.2/dateutils-0.4.2.tar.xz"
  sha256 "ecdae892584098ee9d8f5b14bd555fd63e09d1199cb75aac6b02f09c7e2eb46b"

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
