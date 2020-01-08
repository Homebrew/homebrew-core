class H3 < Formula
  desc "Hexagonal hierarchical geospatial indexing system"
  homepage "https://uber.github.io/h3/"
  url "https://github.com/uber/h3/archive/v3.6.2.tar.gz"
  sha256 "b94fa612f26ceb9f3bcabbb4a425472e548c44d281128842105c71ace651455d"

  bottle do
    cellar :any
    sha256 "2af0d72ef4f2c32b5259e699f2e539090fdd1b75f32e4079bb5ef02624485b48" => :catalina
    sha256 "57ea8592019ec9ae43262b9fba49461611bf360bf2c5ef6bb33d3b938d8f98d2" => :mojave
    sha256 "d78e6b17d7d5dcd8120a85f10f4d00cf3a6475736172626336432628bab74ea2" => :high_sierra
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
