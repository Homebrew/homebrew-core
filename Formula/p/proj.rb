class Proj < Formula
  desc "Cartographic Projections Library"
  homepage "https://proj.org/"
  url "https://github.com/OSGeo/PROJ/releases/download/9.3.0/proj-9.3.0.tar.gz"
  sha256 "91a3695a004ea28db0448a34460bed4cc3b130e5c7d74339ec999efdab0e547d"
  license "MIT"
  head "https://github.com/OSGeo/proj.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:   "dc888f3291b169fc1ea0a53c46c01584c7f543161d9b6a87b976a8b46bd067d8"
    sha256 arm64_ventura:  "013f6cfcbaa0e776c15e0ed456f1baa6f6e1914e170d97cf70cc7fd406ca289c"
    sha256 arm64_monterey: "3dfc90dfa619216cf3989ba9e3536b04dd5229898fdeeaa55cc94fa0a97f098c"
    sha256 arm64_big_sur:  "b8b56f97f9e5ba87a248c049557e8e2055f92c1eea108a38c3c9c130bf6c64ee"
    sha256 sonoma:         "b3171831c68a7ceb5bfb298c3bef0c13575895a4d67f54482d42abd77bf42a74"
    sha256 ventura:        "f0239cab1a3c91c01606ad000a74e8d55131380b12d00d348a0f4da8da90ad75"
    sha256 monterey:       "d28fbbf764987002abbeb2048784ead3a931796cbdc509ccf045118e0955c99e"
    sha256 big_sur:        "3cfd4b0c7b1613df28dcf6926ea0e6a93c98baf07f40079bb671d5825be41437"
    sha256 x86_64_linux:   "a584d20eeb4163958e88213b041ecc76f5ab2b1866f99d511ea818ef92ed9461"
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
  resource "proj-data" do
    url "https://download.osgeo.org/proj/proj-data-1.15.tar.gz"
    sha256 "177fdde749196a5211ee4e74d2b758a9fad2b0a29188e3f58622374f46d11424"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DCMAKE_INSTALL_RPATH=#{rpath}"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    system "cmake", "-S", ".", "-B", "static", *std_cmake_args, "-DBUILD_SHARED_LIBS=OFF"
    system "cmake", "--build", "static"
    lib.install Dir["static/lib/*.a"]
    resource("proj-data").stage do
      cp_r Dir["*"], pkgshare
    end
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
