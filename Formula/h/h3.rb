class H3 < Formula
  desc "Hexagonal hierarchical geospatial indexing system"
  homepage "https://uber.github.io/h3/"
  url "https://github.com/uber/h3/archive/refs/tags/v4.4.1.tar.gz"
  sha256 "9df719eb878f218c203e424dc5ffca9b98eca4d78ba83928773987649ead404d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "68636ef86a67e8737e4c2803218fd9d0148c2dae7c1827b3e9873f4ef2755851"
    sha256 cellar: :any,                 arm64_sequoia: "0328b7e8d86e51153623a95e9207966eca223ac9832b54e769d1597807beb48c"
    sha256 cellar: :any,                 arm64_sonoma:  "14d7541ec9d1099be12c1b66ca1a9eeac3d7cc170d6663ec3cc9d1f8c647d24b"
    sha256 cellar: :any,                 sonoma:        "dc4b1ab1840bed0128839ae704c27909d11fe02a5bf31065ad7ca75793431098"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "549cd280f37fe31ce96f36deb4d212000e17ece12a8f7b7dce395e1b90fce120"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2471501e51c265e88b78973fc2234ebccfd7d4d4210bddddb8744c619060d0a1"
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
