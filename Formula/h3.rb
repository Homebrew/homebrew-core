class H3 < Formula
  desc "Hexagonal hierarchical geospatial indexing system"
  homepage "https://uber.github.io/h3/"
  url "https://github.com/uber/h3/archive/v3.4.4.tar.gz"
  sha256 "9cc84d472bd1352af5bf645ba8087392ca9cbc5abb4f64094a11ee44c675082a"

  bottle do
    cellar :any
    sha256 "9cd1586815a262bea8824259fd798a666d663ae55ffcb296aabce7ce88edc5da" => :mojave
    sha256 "3ba50df38ac5776ff06f46c39e4161bb0a41802f2b4207d4c13a34dab2a850e5" => :high_sierra
    sha256 "ed8cb040305b7a87a7283e9298b8c30d6562d8342795dc7a70442c3ebf72628a" => :sierra
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", "-DBUILD_SHARED_LIBS=YES", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    result = pipe_output("#{bin}/geoToH3 -r 10 --lat 40.689167 --lon -74.044444")
    assert_equal "8a2a1072b59ffff", result.chomp
  end
end
