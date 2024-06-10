class Proj < Formula
  desc "Cartographic Projections Library"
  homepage "https://proj.org/"
  url "https://github.com/OSGeo/PROJ/releases/download/9.4.1/proj-9.4.1.tar.gz"
  sha256 "ffe20170ee2b952207adf8a195e2141eab12cda181e49fdeb54425d98c7171d7"
  license "MIT"
  head "https://github.com/OSGeo/proj.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:   "132e3f4430847e1b9291d5f54a0a97ab67b4d7e3edcc4028a5e663d92fa10abc"
    sha256 arm64_ventura:  "4c876d4d7661c895714788a75d999fa39f0710d4c9663ca83da7e3fafd7a0e1f"
    sha256 arm64_monterey: "cae02ecf57bf23576f36161fdbff13ac00b1c9df700799465a1bf65ac3ff69ca"
    sha256 sonoma:         "e286266c38598cb40b5b8e807cb0fc801a81180daa26a38f09aa04a5c3a08945"
    sha256 ventura:        "fb457f6bc573da71e1c2828a29b883873fa2a8cac01f520457b7502871e09647"
    sha256 monterey:       "96005c3cb466545a7812966a44eb1861bd3f142de4054f1933885e8f601207b0"
    sha256 x86_64_linux:   "32928534aa92e0e0aef6f01d27b264dd8e2083261d44b73e48413aab355deacc"
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
    url "https://download.osgeo.org/proj/proj-data-1.18.tar.gz"
    sha256 "bc18bfe967f51eb05bb2fd61cb7045548d992d20842d2c38f4cbc37d904dfd50"
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
