class Gqlplus < Formula
  desc "Drop-in replacement for sqlplus, an Oracle SQL client"
  homepage "https://gqlplus.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/gqlplus/gqlplus/1.16/gqlplus-1.16.tar.gz"
  sha256 "9e0071d6f8bc24b0b3623c69d9205f7d3a19c2cb32b5ac9cff133dc75814acdd"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "ced72667294e921a6625eff47bdb23df67595692f8f5b4d1ed253eefc4b708ac"
    sha256 cellar: :any,                 arm64_big_sur:  "e93b52a5967e87f0ccc282ad897c4d64b42e0bcf4e41f7ece17186f1fd36bcd6"
    sha256 cellar: :any,                 monterey:       "9af9ffcfb971028cd45c552c13624d26aa5abd0a34df1bba31504070879b474b"
    sha256 cellar: :any,                 big_sur:        "6b4b7972c9c29e749bb0546aa83f756e967aca10793ff70de9bb1711536d929a"
    sha256 cellar: :any,                 catalina:       "2ffb1031a83fe666dc574d17d72b08781dd08e48f1dba88c5c67550472f819df"
    sha256 cellar: :any,                 mojave:         "014190ba5c0c8e5bc88b0d434f6a05d4c26ab0b6e40b96d6fa00f37f02ee078a"
    sha256 cellar: :any,                 high_sierra:    "324544d5383507812e0cc14a6e085697661944588ee1fe56477c67e2bc1c009d"
    sha256 cellar: :any,                 sierra:         "9ad645ec60442256a86ad9bcd081b7adffd4d6ad4cdb47f10814020b53f3200d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d0953b6a9b940124d8922f196387f0f9553d2a36824e41633da5643a0668619f"
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
