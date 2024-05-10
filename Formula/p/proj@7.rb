class ProjAT7 < Formula
  desc "Cartographic Projections Library"
  homepage "https://proj.org/"
  url "https://github.com/OSGeo/PROJ/releases/download/7.2.1/proj-7.2.1.tar.gz"
  sha256 "b384f42e5fb9c6d01fe5fa4d31da2e91329668863a684f97be5d4760dbbf0a14"
  license "MIT"
  revision 1

  bottle do
    sha256 arm64_sonoma:   "a759ebc090bf3e13a4518c5f655f6bfe9a303054c75d207df9c90e218fa98e83"
    sha256 arm64_ventura:  "551208cffb3c201f9d239f0944eee3619e694c36aac19ff947938d1aa830478c"
    sha256 arm64_monterey: "bb024222c2133f0f2b6fb5f2a36e23dd980c70eebcc7fe0d1d5ace49a3f589ec"
    sha256 arm64_big_sur:  "31e013aeb4db0a02863ebba9a5915f7673457f4a5dd1453285f8ac396cf45d19"
    sha256 sonoma:         "459dacda2f93d2abb0928b6a1813ef8b9388d6a4acc5716fc5400c2e716b05d5"
    sha256 ventura:        "95d424ccb442f96c677f7f6051d11adf9d66e8204f0d48a6459baee56be34d8c"
    sha256 monterey:       "d280ab46201b056e8235673eae165dd2acc6fa7b8bcb6f03dba35a5fb35d6d43"
    sha256 big_sur:        "d2a85db83fc71defb511bee6895bc58449a8853e9520d67f75092ec92d14f70e"
    sha256 x86_64_linux:   "2ce63874493d0a44439219060fc33bf35963ee6347052b676c446a3e75a58511"
  end

  keg_only :versioned_formula

  # https://github.com/OSGeo/PROJ/issues/3067
  disable! date: "2024-02-12", because: :versioned_formula

  depends_on "pkg-config" => :build
  depends_on "libtiff"

  uses_from_macos "curl"
  uses_from_macos "sqlite"

  skip_clean :la

  # The datum grid files are required to support datum shifting
  resource "datumgrid" do
    url "https://download.osgeo.org/proj/proj-datumgrid-1.8.zip"
    sha256 "b9838ae7e5f27ee732fb0bfed618f85b36e8bb56d7afb287d506338e9f33861e"
  end

  def install
    (buildpath/"nad").install resource("datumgrid")
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
