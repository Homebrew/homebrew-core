class H3 < Formula
  desc "Hexagonal hierarchical geospatial indexing system"
  homepage "https://uber.github.io/h3/"
  url "https://github.com/uber/h3/archive/v3.6.4.tar.gz"
  sha256 "b80c2eee2b3e645de77893e27ca149e63d3bb6bf95d33e3a384e3f390e2681bb"
  license "Apache-2.0"

  bottle do
    cellar :any
    sha256 "17f1a0f774f7b5a25f1b02fcd19d9edd6fbe2a994aba9ad8bd3e6c964f84ddda" => :catalina
    sha256 "a100aa0c3fc2a23d01aa4b9524d89a3a457b098563df19ae7b8499b43e2eddca" => :mojave
    sha256 "67f1d3f546bbea83339951e7b4428a14852453d2049d9d5c24acf894abdd5ad0" => :high_sierra
  end

  depends_on "cmake" => :build

  # remove in next release
  patch do
    url "https://github.com/uber/h3/pull/362.patch?full_index=1"
    sha256 "a86d8dc0296fcf5fafd3ce071c85725e768886e350905bc88d13a01d98601a94"
  end

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
