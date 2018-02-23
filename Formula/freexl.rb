class Freexl < Formula
  desc "Library to extract data from Excel .xls files"
  homepage "https://www.gaia-gis.it/fossil/freexl/index"
  url "https://www.gaia-gis.it/gaia-sins/freexl-sources/freexl-1.0.5.tar.gz"
  sha256 "3dc9b150d218b0e280a3d6a41d93c1e45f4d7155829d75f1e5bf3e0b0de6750d"

  bottle do
    cellar :any
    sha256 "7ca25e585235a32101d4609650add1b1958f802abb4ed27344070f22b30aef3b" => :high_sierra
    sha256 "0acd882858992391ab7538d5ba0b7759e6ac74a66cbc2d3ab7687e21359153be" => :sierra
    sha256 "3fe58df5c022ebb71b420fa3ce3cd6d672bea6f51b4fcb7231716305add6d768" => :el_capitan
  end

  option "without-test", "Skip compile-time make checks"

  deprecated_option "without-check" => "without-test"

  depends_on "doxygen" => [:optional, :build]

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}",
                          "--disable-silent-rules"

    system "make", "check" if build.with? "test"
    system "make", "install"

    if build.with? "doxygen"
      system "doxygen"
      doc.install "html"
    end
  end
end
