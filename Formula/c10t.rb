class C10t < Formula
  desc "Minecraft cartography tool"
  homepage "https://github.com/udoprog/c10t"
  url "https://github.com/udoprog/c10t/archive/1.7.tar.gz"
  sha256 "0e5779d517105bfdd14944c849a395e1a8670bedba5bdab281a0165c3eb077dc"

  bottle do
    cellar :any
    sha256 "dc393e5a17643389d4f9ce45157a61d053ae30847bcbbb2ec9b36d743cec2447" => :mojave
    sha256 "eaf300efd0b907d3cead85f0e2338b3ebc7162143d29874e841504a2645a126d" => :high_sierra
    sha256 "81effa3d15bf65343a17befabbab5ddf9e40953336d4dec27b379e62fac98439" => :sierra
    sha256 "a7e8fa78424c478351d68d8db77577b1d93208da645e975be9dfd5696d0cf851" => :el_capitan
    sha256 "bcda91a0b11bf1fc75fa5235901ad0c43c22b058846f8b6785daf35fcc10e9af" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "freetype"

  # Needed to compile against newer boost
  # Can be removed for the next version of c10t after 1.7
  # See: https://github.com/udoprog/c10t/pull/153
  patch do
    url "https://github.com/udoprog/c10t/commit/4a392b9f06d08c70290f4c7591e84ecdbc73d902.diff?full_index=1"
    sha256 "5e1c6d9906c3cf2aaaceca2570236585d3404ab4107cfb9169697e9cab30072d"
  end

  # Fix freetype detection; adapted from this upstream commit:
  # https://github.com/udoprog/c10t/commit/2a2b8e49d7ed4e51421cc71463c1c2404adc6ab1
  patch do
    url "https://gist.githubusercontent.com/mistydemeo/f7ab02089c43dd557ef4/raw/a0ae7974e635b8ebfd02e314cfca9aa8dc95029d/c10t-freetype.diff"
    sha256 "9fbb7ccc643589ac1d648e105369e63c9220c26d22f7078a1f40b27080d05db4"
  end

  # Ensure zlib header is included for libpng; fixed upstream
  patch do
    url "https://github.com/udoprog/c10t/commit/800977bb23e6b4f9da3ac850ac15dd216ece0cda.diff?full_index=1"
    sha256 "5275cb43178b2f6915b14d214ec47c9182e63ff23771426b71f3c0a5450721bf"
  end

  def install
    inreplace "test/CMakeLists.txt", "boost_unit_test_framework", "boost_unit_test_framework-mt"
    system "cmake", ".", *std_cmake_args
    system "make"
    bin.install "c10t"
  end

  test do
    system "#{bin}/c10t", "--list-colors"
  end
end
