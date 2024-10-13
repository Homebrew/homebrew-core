class Proj < Formula
  desc "Cartographic Projections Library"
  homepage "https://proj.org/"
  url "https://github.com/OSGeo/PROJ/releases/download/9.5.0/proj-9.5.0.tar.gz"
  sha256 "659af0d558f7c5618c322fde2d3392910806faee8684687959339021fa207d99"
  license "MIT"
  head "https://github.com/OSGeo/proj.git", branch: "master"

  bottle do
    sha256 arm64_sequoia: "dcc7371d2a62f8035d599c5a8ff7bf410e54bb3b4fdace1b4acc4043149d8a22"
    sha256 arm64_sonoma:  "2a1b74965d05b95ab482cabf2e7bc0d55cc9e196b215dc782ec4624a599ddbe0"
    sha256 arm64_ventura: "ab237962dfbb7613195e70f58e7f82a94b2c3d4e1f9b034f8d7686a8fdea88a1"
    sha256 sonoma:        "ff478dcefaaaa025e43f3718b53a57742f29d6a0e8e7ecd26d18e7f0c56bf06f"
    sha256 ventura:       "9abf5ab1f71895f10698f6d26f88be8d6618c1d5388a7eadd5e8f59105d516b2"
    sha256 x86_64_linux:  "aa9ddc1ba112d2022f99f71d2e905dbbad57987c5974af1bf9150bf21fdb7abe"
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
    url "https://download.osgeo.org/proj/proj-data-1.19.zip"
    sha256 "6a92707122f8b22d3bdbadb3a1792425217ee378cb4ffa0c49d2455653c5e17e"
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
