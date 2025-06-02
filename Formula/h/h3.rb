class H3 < Formula
  desc "Hexagonal hierarchical geospatial indexing system"
  homepage "https://uber.github.io/h3/"
  url "https://github.com/uber/h3/archive/refs/tags/v4.2.1.tar.gz"
  sha256 "1b51822b43f3887767c5a5aafd958fca72b72fc454f3b3f6eeea31757d74687d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7be49d20c152264ea989f2e96be5b0b4cdabc41769a3577ceb7d6c7e0a6b481b"
    sha256 cellar: :any,                 arm64_sonoma:  "3ae20dda8f2138be8d79d77a20d82f92caa7a7a0828c9a0aeb4e2f64b29cc8db"
    sha256 cellar: :any,                 arm64_ventura: "a72d460ce48392a312f9713131c9e526c32421a30f862c9c65ef2c9c009dbf0d"
    sha256 cellar: :any,                 sonoma:        "d0849d830aca26ddaff870a0d725dfc24ac2e3e8cf827a4f89bdb71587ba2d8b"
    sha256 cellar: :any,                 ventura:       "32cceafc84e5fa584523be35756aa6cdc437457b2712cd0a2d1a03bdea31b1b1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d309c31edb9ba1b7b046df61e2b819791e0c0ca2fe54be55567621953fc48dbb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3410f81c6368a364ef33073653ec88928912738e9f653b99a3b01694dd510b41"
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
