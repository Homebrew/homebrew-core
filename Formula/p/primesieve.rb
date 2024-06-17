class Primesieve < Formula
  desc "Fast C/C++ prime number generator"
  homepage "https://github.com/kimwalisch/primesieve"
  url "https://github.com/kimwalisch/primesieve/archive/refs/tags/v12.3.tar.gz"
  sha256 "147105d9d41a17a9eee0640182c106454ec48b0d1bf54ced7b2b9ddad8a0f8b4"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7055a1855d506059a70c5427ef6565330837a12b16320d8a82e8f37d6f57aa59"
    sha256 cellar: :any,                 arm64_ventura:  "6ff52250d944d0b90f9fd54af3a13eaa23444d18b88e8c5126db112775821f9f"
    sha256 cellar: :any,                 arm64_monterey: "5febafd15c20084902c5934a60b8ce25b76913d205814f583ee617d0facef161"
    sha256 cellar: :any,                 sonoma:         "6b971374824a919c9a1079d18aefe34e65354e96a28f732fdf3ddbc6d354809b"
    sha256 cellar: :any,                 ventura:        "2028b4c30c6ff66f0878aaebcd41da9c9df7274818647d092a1408d96abfd39c"
    sha256 cellar: :any,                 monterey:       "b509c48a61020dc0b926fbba2b7369561e6427b13aad2775e908c026d7dcbced"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b95d71c8550b45da40a3d29469d8db8af09b4e403fb2fb0c2c3d4d0f4006b605"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_RPATH=#{rpath}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system "#{bin}/primesieve", "100", "--count", "--print"
  end
end
