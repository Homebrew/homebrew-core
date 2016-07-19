class Gqlplus < Formula
  desc "Drop-in replacement for sqlplus, an Oracle SQL client"
  homepage "http://gqlplus.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/gqlplus/gqlplus/1.16/gqlplus-1.16.tar.gz"
  sha256 "9e0071d6f8bc24b0b3623c69d9205f7d3a19c2cb32b5ac9cff133dc75814acdd"

  bottle do
    cellar :any
    sha256 "db6238610872b86147a9388428049f873feb2e1cb9907b5f83cd1a1a99765999" => :el_capitan
    sha256 "e5c2b76da875f812e265298b826ae61f82feaabff0d4c168020c972392591e7d" => :yosemite
    sha256 "7d3182e52181391c1368abe4f0a5b55d337d6d4fbf44841f272724ba33094837" => :mavericks
  end

  depends_on "readline"

  def install
    # Fix the version
    # Reported 18 Jul 2016: https://sourceforge.net/p/gqlplus/bugs/43/
    inreplace "gqlplus.c",
      "#define VERSION          \"1.15\"",
      "#define VERSION          \"1.16\""

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gqlplus -h")
  end
end
