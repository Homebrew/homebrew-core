class H3 < Formula
  desc "Hexagonal hierarchical geospatial indexing system"
  homepage "https://uber.github.io/h3/"
  url "https://github.com/uber/h3/archive/v3.6.4.tar.gz"
  sha256 "b80c2eee2b3e645de77893e27ca149e63d3bb6bf95d33e3a384e3f390e2681bb"
  license "Apache-2.0"

  bottle do
    cellar :any
    rebuild 1
    sha256 "09a6545834974c43aec33b061abf50fac5cc58c0dc115f7aaacb5c787d5de541" => :catalina
    sha256 "ca32e11077bf894aa153fb0a89bb1f6b34f6a4964224d29cf422c4ad0bd817d8" => :mojave
    sha256 "b8bc7c33678f9cc98c2abd765d410c1805bc449c4d8c66559be18eed97f270da" => :high_sierra
  end

  depends_on "cmake" => :build

  # remove in next release
  patch do
    url "https://github.com/uber/h3/commit/de1a7cb27891ed8b9934288ee645a4b307553c76.patch?full_index=1"
    sha256 "1c31a9b6136190c8f8097cc3112de0a2a4d3074c3170ad4af21673cdf565162b"
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
