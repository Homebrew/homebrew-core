class Gqlplus < Formula
  desc "Drop-in replacement for sqlplus, an Oracle SQL client"
  homepage "https://gqlplus.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/gqlplus/gqlplus/1.16/gqlplus-1.16.tar.gz"
  sha256 "9e0071d6f8bc24b0b3623c69d9205f7d3a19c2cb32b5ac9cff133dc75814acdd"
  revision 2

  bottle do
    cellar :any
    sha256 "014190ba5c0c8e5bc88b0d434f6a05d4c26ab0b6e40b96d6fa00f37f02ee078a" => :mojave
    sha256 "324544d5383507812e0cc14a6e085697661944588ee1fe56477c67e2bc1c009d" => :high_sierra
    sha256 "9ad645ec60442256a86ad9bcd081b7adffd4d6ad4cdb47f10814020b53f3200d" => :sierra
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
