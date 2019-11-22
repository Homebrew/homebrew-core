class H3 < Formula
  desc "Hexagonal hierarchical geospatial indexing system"
  homepage "https://uber.github.io/h3/"
  url "https://github.com/uber/h3/archive/v3.6.1.tar.gz"
  sha256 "2610892706f13a616626740a4e474af93568fcb332e8ee2497bf5c3be60065f2"

  bottle do
    cellar :any
    sha256 "995bdeb47df1e9a516f0d1723bfa636c3292760b0bf01e5553b6ef014e56d686" => :catalina
    sha256 "091d1b56208b92af6ab304e904b72059a4bc3700a23564daba1fac9e68ae2ee4" => :mojave
    sha256 "bc195a3205e34ad22cf4c6776961c1c969330982f69b8d9314f37a79e2359ca2" => :high_sierra
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
