class Dateutils < Formula
  desc "Tools to manipulate dates with a focus on financial data"
  homepage "https://www.fresse.org/dateutils/"
  url "https://github.com/hroptatyr/dateutils/releases/download/v0.4.4/dateutils-0.4.4.tar.xz"
  sha256 "a9cc2efbb10681130ac725946984e12330e94f43877d865d7f5c131dcf09c84f"

  bottle do
    sha256 "3e06c17b40904a6827276ce7263a2b809583d6c7357ccf674f10c86decdab47d" => :mojave
    sha256 "99b4afaec6244d4a4b1eb32463750b75499e1a6ef31ba5337a5c9eb713f6343b" => :high_sierra
    sha256 "107c32964dd12201f5547c5a19eeeb0956359c9ee602c28ae87218883f2b6a67" => :sierra
    sha256 "626f763211da4944b92344061e094e8597e043c81e3e42c2322ec85eaf4229e2" => :el_capitan
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
