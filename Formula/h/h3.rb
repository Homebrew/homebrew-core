class H3 < Formula
  desc "Hexagonal hierarchical geospatial indexing system"
  homepage "https://uber.github.io/h3/"
  url "https://github.com/uber/h3/archive/refs/tags/v4.1.0.tar.gz"
  sha256 "ec99f1f5974846bde64f4513cf8d2ea1b8d172d2218ab41803bf6a63532272bc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "a1e8ac308293e2f9288c90ba38975297fe65b9e897668447d70ec7a549dfc14e"
    sha256 cellar: :any,                 arm64_sonoma:   "1098253ac8e6458dd6c285b07996131776ab985e4177d3a127e4c807d27d02ed"
    sha256 cellar: :any,                 arm64_ventura:  "44686e792f5b905666c5200c15e31ac3023e1148b474443c0f202322620d600c"
    sha256 cellar: :any,                 arm64_monterey: "bf4c9ea8b3140be46dedb8aa9b91cde186835ba1cc53c720e129bb36b58bfbc8"
    sha256 cellar: :any,                 arm64_big_sur:  "d3afae09e49800840dbeb968fa454c82753f8cb9d9234ac2a2887e7ff210f172"
    sha256 cellar: :any,                 sonoma:         "2dfca31563c6b7e4d3dc94d9fd48eb9c2611ce4d05d73bf77cbd3aa430f02bb4"
    sha256 cellar: :any,                 ventura:        "519d67be32f5f41440a487eb85a0dc3055e9a4983fb6bb39a10aaeb388f543e3"
    sha256 cellar: :any,                 monterey:       "6de52d5a62572d73f9e2f7fa062971c4bfb52da64265063a2528a146f0c0ecff"
    sha256 cellar: :any,                 big_sur:        "c6119a992a3e994b8b3dcb1d8cdd9a783bb000f93c9ad60ed3d24f60db1bc0ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea347ced55cef67aa8d834815798f19b7f64db12f7a76cd2f992c8047437161f"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    result = pipe_output("#{bin}/latLngToCell -r 10 --lat 40.689167 --lng -74.044444")
    assert_equal "8a2a1072b59ffff", result.chomp
  end
end
