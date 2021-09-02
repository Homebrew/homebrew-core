class Proj < Formula
  desc "Cartographic Projections Library"
  homepage "https://proj.org/"
  url "https://github.com/OSGeo/PROJ/releases/download/8.1.1/proj-8.1.1.tar.gz"
  sha256 "82f1345e5fa530c407cb1fc0752e83f8d08d2b98772941bbdc7820241f7fada2"
  license "MIT"

  bottle do
    sha256 arm64_big_sur: "07d461835b6a6f035345800387f80a79281304e722894d9f3d999a4564d0bd3f"
    sha256 big_sur:       "12230b16ab649e99e65aebd6d7f932aa20e9c7c9198470325f0bc25fda44d598"
    sha256 catalina:      "dd546af1c56863f71f9fef6304a9d27d4bf988396b8970b6c4175123ac8ea588"
    sha256 mojave:        "7c932f415d358b401fbd35e2edbc7154a0ce2ed2b7d90e3e7c772ff692e43539"
    sha256 x86_64_linux:  "ece361d33ea28a83de82570049ab567064e92efdf7777f291db6229d546290b8"
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
