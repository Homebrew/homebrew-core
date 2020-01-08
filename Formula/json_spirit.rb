class JsonSpirit < Formula
  desc "C++ JSON parser/generator"
  homepage "https://www.codeproject.com/Articles/20027/JSON-Spirit-A-C-JSON-Parser-Generator-Implemented"
  url "https://github.com/png85/json_spirit/archive/json_spirit-4.0.8.tar.gz"
  # Current release is misnamed on GitHub, previous versioning scheme and homepage
  # dictate the release as "4.08".
  version "4.08"
  sha256 "43829f55755f725c06dd75d626d9e57d0ce68c2f0d5112fe9a01562c0501e94c"

  bottle do
    cellar :any
    sha256 "31aaf302e4238b13797722028ac46a7deade1df4f042b46feb7d455cb05e4599" => :catalina
    sha256 "2cec376e843919e2f3693e73be0e3a2c6a6f3b283e503b51d42108c5471e8091" => :mojave
    sha256 "55299a7931b4bbbcf1ee5c576fe35283373279cc95b3b5126696ad5741f3d072" => :high_sierra
    sha256 "0dc2370a736a065b47f6f83f8ed292209fc978005a720de8653e32cc1c568cce" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "boost"

  def install
    args = std_cmake_args
    args << "-DBUILD_STATIC_LIBRARIES=ON"

    system "cmake", *args
    system "make"

    args = std_cmake_args
    args << "-DBUILD_STATIC_LIBRARIES=OFF"
    system "cmake", *args
    system "make", "install"
  end
end
