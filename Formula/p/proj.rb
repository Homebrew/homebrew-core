class Proj < Formula
  desc "Cartographic Projections Library"
  homepage "https://proj.org/"
  url "https://github.com/OSGeo/PROJ/releases/download/9.4.0/proj-9.4.0.tar.gz"
  sha256 "3643b19b1622fe6b2e3113bdb623969f5117984b39f173b4e3fb19a8833bd216"
  license "MIT"
  head "https://github.com/OSGeo/proj.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:   "d33f9b6ad7e5a332ea281b3d8e973a854f440928be57d18593101db3f708b103"
    sha256 arm64_ventura:  "fbb6a0e2f9e71592b69cc30835fe445905e634493586f51177e952fe16e3e72c"
    sha256 arm64_monterey: "a867c571d380f38d2f5ce1e1ef7c03b12f651ff7314e24a11cb06d364b82aaaf"
    sha256 sonoma:         "b9e145d8f013f71023eac82c67d36f374ecd059babab4c149cd490652f08126f"
    sha256 ventura:        "5e6d12e0cd0ea6e8848d40f79d53d654ae2bf0b88f3b61ed344271b1761af344"
    sha256 monterey:       "c9f5cd112035683c7617df723179c3de553a63c14aff0f306956089af28c97dc"
    sha256 x86_64_linux:   "014a61485ed3baf64749505530c4f8696d30f3da882853e7f6b6916043b50ad2"
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
    url "https://download.osgeo.org/proj/proj-data-1.17.tar.gz"
    sha256 "a79017954c78f2b46e1619f723d2a7a573c466c15f0b4cd1e8bdefff9b2cab30"
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
