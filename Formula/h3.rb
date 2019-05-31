class H3 < Formula
  desc "Hexagonal hierarchical geospatial indexing system"
  homepage "https://uber.github.io/h3/"
  url "https://github.com/uber/h3/archive/v3.4.3.tar.gz"
  sha256 "92fad4467e0af343dbf3d003da09bd2df6a1350f46fcc569ca33648593d78f25"

  bottle do
    cellar :any
    sha256 "d6b222684aa002d2299354eac1afbf84864ae0180f767b67fef6adbe63a80bfc" => :mojave
    sha256 "aedb21b22ef839267946e2ca37ec13eea92bac2519390e9e98f4151ff16a1070" => :high_sierra
    sha256 "6a32d2da626b73de95d0625f7d2f1cdeef78229d7aae35e4a71554a3a8001f53" => :sierra
  end

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
