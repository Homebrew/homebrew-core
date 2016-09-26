class Gqlplus < Formula
  desc "Drop-in replacement for sqlplus, an Oracle SQL client"
  homepage "http://gqlplus.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/gqlplus/gqlplus/1.16/gqlplus-1.16.tar.gz"
  sha256 "9e0071d6f8bc24b0b3623c69d9205f7d3a19c2cb32b5ac9cff133dc75814acdd"

  bottle do
    cellar :any
    sha256 "06a235847ab08c8c89f587896f0c2e8c32cd4b406c929f4125facf6a4c558e9d" => :sierra
    sha256 "6a8b5da1b7a2a112de1df19024a3391d4b59f4620ea709d4643ee9cdb5ec4ee7" => :el_capitan
    sha256 "3126ca284b757d5dd0795895e2253f8b41b08d6f5616e5e20eaed11b18452a43" => :yosemite
    sha256 "dcd4f4950702fea5fb85a3dab05909c2362bbf9d21d3ddd481efd1e67436c3f0" => :mavericks
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
