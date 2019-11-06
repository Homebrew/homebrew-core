class H3 < Formula
  desc "Hexagonal hierarchical geospatial indexing system"
  homepage "https://uber.github.io/h3/"
  url "https://github.com/uber/h3/archive/v3.6.0.tar.gz"
  sha256 "0f07d477d057c8b34263a8e173d86fe7b5ca3d6f35be81e5f4db886b81281d9a"

  bottle do
    cellar :any
    sha256 "2445fd676b354d9378eddc1e568e0297af4dbaeaa3d8fdd2c581e40d3dd6b475" => :catalina
    sha256 "2dc693483b0d80f03d1ea20713cfe03b45ea88de2e694d0965009127c13f5f40" => :mojave
    sha256 "a18b465ee41ebb5ac788d909f4680a93e03881fdca515d8506d036d4ad825b36" => :high_sierra
    sha256 "0ebd3445e13d8a4e9d8aaac7b281a30214a2573b06e65d05cdc74ba234bbe7a0" => :sierra
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
