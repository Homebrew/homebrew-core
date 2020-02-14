class Proj < Formula
  desc "Cartographic Projections Library"
  homepage "https://proj4.org/"
  url "https://download.osgeo.org/proj/proj-6.3.1.tar.gz"
  sha256 "6de0112778438dcae30fcc6942dee472ce31399b9e5a2b67e8642529868c86f8"

  bottle do
    sha256 "41cbb54cae6d39c78479262d376fb2c251f4f5d6fffd19b3efae7328479879fd" => :catalina
    sha256 "4a6e50d10a6f86646fd808e82afbe97fd2d9519c86843b6b3befcee1fcbb0372" => :mojave
    sha256 "c3cc857342fb66bcd184abab63ac50e15f4e9fbcf09c95cf614227abe4f2ee47" => :high_sierra
  end

  head do
    url "https://github.com/OSGeo/proj.4.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build

  conflicts_with "blast", :because => "both install a `libproj.a` library"

  skip_clean :la

  # The datum grid files are required to support datum shifting
  resource "datumgrid" do
    url "https://download.osgeo.org/proj/proj-datumgrid-1.8.zip"
    sha256 "b9838ae7e5f27ee732fb0bfed618f85b36e8bb56d7afb287d506338e9f33861e"
  end

  def install
    (buildpath/"nad").install resource("datumgrid")

    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test").write <<~EOS
      45d15n 71d07w Boston, United States
      40d40n 73d58w New York, United States
      48d51n 2d20e Paris, France
      51d30n 7'w London, England
    EOS
    match = <<~EOS
      -4887590.49\t7317961.48 Boston, United States
      -5542524.55\t6982689.05 New York, United States
      171224.94\t5415352.81 Paris, France
      -8101.66\t5707500.23 London, England
    EOS

    output = shell_output("#{bin}/proj +proj=poly +ellps=clrk66 -r #{testpath}/test")
    assert_equal match, output
  end
end
