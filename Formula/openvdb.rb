class Openvdb < Formula
  desc "Sparse volume processing toolkit"
  homepage "https://www.openvdb.org/"
  url "https://github.com/AcademySoftwareFoundation/openvdb/archive/v8.0.0.tar.gz"
  sha256 "04a28dc24a744f8ac8bbc5636a949628edb02b7c84db24ad795429c8c739a9ee"
  license "MPL-2.0"
  head "https://github.com/AcademySoftwareFoundation/openvdb.git"

  bottle do
    sha256 "1b74f7cf86f366e2372bd13a7afad62f54a7f9fc16c46d3be31ab0d465fbc1e9" => :big_sur
    sha256 "eff4b6640981a892c5fd45a3e5df88f43b7762184dfe84bd8707de6229b82a5a" => :arm64_big_sur
    sha256 "b69e45be52d2f1e42bad36270c796a84ec3825aa50658d6cdfdb90fe2293af5f" => :catalina
    sha256 "8c8c2ea3adbdf79ab39f3ab10ec99c6663260eaef0863ce28176d7491f8d8abb" => :mojave
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "boost"
  depends_on "c-blosc"
  depends_on "glfw"
  depends_on "ilmbase"
  depends_on "jemalloc"
  depends_on "openexr"
  depends_on "tbb"

  resource "test_file" do
    url "https://artifacts.aswf.io/io/aswf/openvdb/models/cube.vdb/1.0.0/cube.vdb-1.0.0.zip"
    sha256 "05476e84e91c0214ad7593850e6e7c28f777aa4ff0a1d88d91168a7dd050f922"
  end

  def install
    cmake_args = [
      "-DDISABLE_DEPENDENCY_VERSION_CHECKS=ON",
      "-DOPENVDB_BUILD_DOCS=ON",
    ]

    mkdir "build" do
      system "cmake", "..", *std_cmake_args, *cmake_args
      system "make", "install"
    end
  end

  test do
    resource("test_file").stage testpath
    system "#{bin}/vdb_print", "-m", "cube.vdb"
  end
end
