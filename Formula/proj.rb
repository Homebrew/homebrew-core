class Proj < Formula
  desc "Cartographic Projections Library"
  homepage "https://proj4.org/"
  url "https://download.osgeo.org/proj/proj-5.2.0.tar.gz"
  sha256 "ef919499ffbc62a4aae2659a55e2b25ff09cccbbe230656ba71c6224056c7e60"

  bottle do
    sha256 "bead47d7970ed3a59ef4c9567e86cf834fcaf01a1a8b63efeb372b62e2f39b83" => :mojave
    sha256 "80caa7d9b6ffc5cee9c397b8821b834a16b37c05cd0acd0262f825fa95eb8e08" => :high_sierra
    sha256 "1906c694029b8a01fbd912733b3c9ba295f4b8ba9d32d0d3f8f2b549b179d04a" => :sierra
    sha256 "9cbf5a3dfb98c5b5ee82a3e4b8d9d0f927a4d45e514d99a71ca78eb123d5cafe" => :el_capitan
  end

  head do
    url "https://github.com/OSGeo/proj.4.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

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
    assert_equal match,
                 `#{bin}/proj +proj=poly +ellps=clrk66 -r #{testpath}/test`
  end
end
