class H3 < Formula
  desc "Hexagonal hierarchical geospatial indexing system"
  homepage "https://uber.github.io/h3/"
  url "https://github.com/uber/h3/archive/v3.6.3.tar.gz"
  sha256 "3ba219959ecb0ef6956f05113aa659d7b605e4eebbdca561b8243ce309e4684e"

  bottle do
    cellar :any
    sha256 "649c3d7ce2d3654e5ac0cbd524aae73e3eee7554a7e08140e7343ecc663454ff" => :catalina
    sha256 "af8fc06065e83d300d21161a6d67e7d517910a7b24d8ac36c69dccd0dadddb52" => :mojave
    sha256 "e85638ef4bd72a13fcbc0d2e1c5c8580880e40775343056db243095c945f8c19" => :high_sierra
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
