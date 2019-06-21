class H3 < Formula
  desc "Hexagonal hierarchical geospatial indexing system"
  homepage "https://uber.github.io/h3/"
  url "https://github.com/uber/h3/archive/v3.4.4.tar.gz"
  sha256 "9cc84d472bd1352af5bf645ba8087392ca9cbc5abb4f64094a11ee44c675082a"

  bottle do
    cellar :any
    sha256 "e9b15fa66f8e00bccc736e16d8826d892b8f063a22b4f843d77e9a414ac59fa9" => :mojave
    sha256 "0ca81a5f775f7db015c8810f5ba41600ab750cce909dbb95a162fa66c75f6ce8" => :high_sierra
    sha256 "96b45bc089d9a784575659704c06fa38f5bef322dca3f7528e2afbc20c9120c9" => :sierra
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
