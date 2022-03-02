class Proj < Formula
  desc "Cartographic Projections Library"
  homepage "https://proj.org/"
  url "https://github.com/OSGeo/PROJ/releases/download/9.0.0/proj-9.0.0.tar.gz"
  sha256 "0620aa01b812de00b54d6c23e7c5cc843ae2cd129b24fabe411800302172b989"
  license "MIT"
  head "https://github.com/OSGeo/proj.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "41cda6ba8300463d30e7779df5733439c6bfbec75ea7444860e2077932a021f8"
    sha256 arm64_big_sur:  "8866b82dd9abc74cd4b641384701ef0667a11980a5b9fc8e74387bed8bd61b9d"
    sha256 monterey:       "8a3e638910eedcf4048f0dad2a7b2162436a3fc4a69ce7cc97976030cdfbc124"
    sha256 big_sur:        "69b22cef6b1b22c15243b43f63cc40b53902c192a6f2fc9edfe105b61f7e8b39"
    sha256 catalina:       "e3ff7034a575136fb142157af00dd1fcc0972ca76be08a9a09dadda173744564"
    sha256 x86_64_linux:   "1e9845b299ed00a4fc564372a7a8a7586897ea6aa8cce0a0d182ee0dbe775d38"
  end

  depends_on "cmake" => :build
  depends_on "libtool" => :build
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
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DCMAKE_INSTALL_RPATH=#{rpath}"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
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
