class H3 < Formula
  desc "Hexagonal hierarchical geospatial indexing system"
  homepage "https://uber.github.io/h3/"
  url "https://github.com/uber/h3/archive/v3.4.2.tar.gz"
  sha256 "c6ff7bb9d93e25e5133f8c79c515407994349ad1606d0fd7f9f4e90592c1bd7c"

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", "-DBUILD_SHARED_LIBS=YES", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    result = pipe_output("#{bin}/geoToH3 10", "40.689167 -74.044444")
    assert_equal "8a2a1072b59ffff", result.chomp
  end
end
