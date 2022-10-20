class Primesieve < Formula
  desc "Fast C/C++ prime number generator"
  homepage "https://github.com/kimwalisch/primesieve"
  url "https://github.com/kimwalisch/primesieve/archive/v8.0.tar.gz"
  sha256 "9fba723221535dbf1e30c582c5009eeb032464704da01a0c8541d8cf2a698803"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "684ddb9b6b4ebc99ad9da93ea2955efdd250c1e83b657bb0f17ab628ea19ae2a"
    sha256 cellar: :any,                 arm64_big_sur:  "fbf539bc91b9ab2aacfc43ba046af6cb109d89cc7c9d80141a2e0bbe8f05248f"
    sha256 cellar: :any,                 monterey:       "0582cb5f624fc3e55c83034e326961691579b59a6e6293e5ad9adc64de7a1088"
    sha256 cellar: :any,                 big_sur:        "3990e01b489f7cc4fd8251f0101dbff10bc93d0f32ceef637e9fd6e55ae2f5a6"
    sha256 cellar: :any,                 catalina:       "00c41adfde1d79f764fe4fceff86dac312b0213e28b089cdbc625a53d9fc6af7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "79d9d2cc14c8145bf57832fd02f92de7acc9f42d0a717be55c07e313e2ff28fb"
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
