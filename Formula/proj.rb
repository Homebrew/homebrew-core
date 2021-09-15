class Proj < Formula
  desc "Cartographic Projections Library"
  homepage "https://proj.org/"
  url "https://github.com/OSGeo/PROJ/releases/download/8.1.1/proj-8.1.1.tar.gz"
  sha256 "82f1345e5fa530c407cb1fc0752e83f8d08d2b98772941bbdc7820241f7fada2"
  license "MIT"

  bottle do
    sha256 arm64_big_sur: "d4abd8f4d48c37d171cd694078b2f6fbc0c21f6c650b060429a90f0d6805ea4e"
    sha256 big_sur:       "1bd3193543e722b62af850ca4c303db1b510ed63abb9e15d9f255c635fb51732"
    sha256 catalina:      "e5f1494677c8ee96f79d517bf2facbaa8de6761538f1101907fd45e4d1ec8806"
    sha256 mojave:        "f94155a3593b64f43e1e4eba81e10ce398194d069658d360501388129c82011c"
    sha256 x86_64_linux:  "119ba4f1fa22615fa28a629bd714da2d8db5c194b83ef59b642edca5c986090b"
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
