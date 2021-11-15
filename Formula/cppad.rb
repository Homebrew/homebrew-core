class Cppad < Formula
  desc "Differentiation of C++ Algorithms"
  homepage "https://www.coin-or.org/CppAD"
  # Stable versions have numbers of the form 201x0000.y
  url "https://github.com/coin-or/CppAD/archive/20210000.8.tar.gz"
  sha256 "465a462329fb62110c4799577178d1f28d8c0083b385b7ea08ac82bb98873844"
  license "EPL-2.0"
  version_scheme 1
  head "https://github.com/coin-or/CppAD.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "fede696ea9899a66579f17c71657bd29ea1b0b93ec32e110da62abebbb2c4c15"
    sha256 cellar: :any,                 arm64_big_sur:  "f1e290d82781bd8a6eb2d834141f9c02bb7006ae26113bedf3ff518eaf6c93bf"
    sha256 cellar: :any,                 monterey:       "b52e0d8f8dc2c9c71f4f32ee74efcce38536b7802fd03c4c14c70eff61742d64"
    sha256 cellar: :any,                 big_sur:        "52998109aba462d55b4dc2dcf3a1d3bde03ed13b0f736985d8725fff163f6b01"
    sha256 cellar: :any,                 catalina:       "9cedc9b79c879b310618c4f423ab4ec40d5e44b668c95e83c701e0fcc63ecb47"
    sha256 cellar: :any,                 mojave:         "531ea9476520b4ebaa94a2cdc73d5e668d47ea042d6130f745f9dc8323d67c52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a265722ea9479807714b7cc6aa415e2a5562ae8b61ff7e149f3f9441359f9b7a"
  end

  depends_on "cmake" => :build

  def install
    ENV.cxx11

    mkdir "build" do
      system "cmake", "..", *std_cmake_args,
                      "-Dcppad_prefix=#{prefix}"
      system "make", "install"
    end

    pkgshare.install "example"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <cassert>
      #include <cppad/utility/thread_alloc.hpp>

      int main(void) {
        extern bool acos(void);
        bool ok = acos();
        assert(ok);
        return static_cast<int>(!ok);
      }
    EOS

    system ENV.cxx, "#{pkgshare}/example/general/acos.cpp", "-std=c++11", "-I#{include}",
                    "test.cpp", "-o", "test"
    system "./test"
  end
end
