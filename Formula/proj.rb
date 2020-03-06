class Proj < Formula
  desc "Cartographic Projections Library"
  homepage "https://proj4.org/"
  url "https://download.osgeo.org/proj/proj-7.0.0.tar.gz"
  sha256 "ee0e14c1bd2f9429b1a28999240304c0342ed739ebaea3d4ff44c585b1097be8"

  bottle do
    sha256 "8016d7ac0def06a09f219ad4b567cee8ee96c5f3f5dd9b7ab2a10970aaa9fc85" => :catalina
    sha256 "9510aa998aeab55db840127a70743322063ac9e95c0ff615410e6c4a048e1b64" => :mojave
    sha256 "168b8ebbee214dcb84e0bf8f1db600f000d6f95c43daee76b59dc96d65191ad4" => :high_sierra
  end

  head do
    url "https://github.com/OSGeo/proj.4.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libtiff"

  uses_from_macos "sqlite"

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
