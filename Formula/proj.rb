class Proj < Formula
  desc "Cartographic Projections Library"
  homepage "https://proj.org/"
  url "https://github.com/OSGeo/PROJ/releases/download/8.0.1/proj-8.0.1.tar.gz"
  sha256 "e0463a8068898785ca75dd49a261d3d28b07d0a88f3b657e8e0089e16a0375fa"
  license "MIT"

  bottle do
    sha256 arm64_big_sur: "a4da85e7db113fc2286146cc9a250df2877c36fd766a373915e1b673b3c6ce82"
    sha256 big_sur:       "2cdcd5418e147d57ec413c5977e05cd56291f138416033810aa075afe873cf1f"
    sha256 catalina:      "cf990e76cb867cc5896631a6c3c813205676a4c9fbf096d82ec67b7aef764066"
    sha256 mojave:        "78be51044cce3f368ef821f1adc3e0ae6e353ee67c28d498f32828fb56d46bf2"
  end

  head do
    url "https://github.com/OSGeo/proj.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libtiff"

  uses_from_macos "curl"
  uses_from_macos "sqlite"

  conflicts_with "blast", because: "both install a `libproj.a` library"

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
