class Cppad < Formula
  desc "Differentiation of C++ Algorithms"
  homepage "https://www.coin-or.org/CppAD"
  # Stable versions have numbers of the form 201x0000.y
  url "https://github.com/coin-or/CppAD/archive/20210000.7.tar.gz"
  sha256 "271e13fd94dd618b8a55113a1c0c441ea7f3fcf06499841773c0c81a6bee960b"
  license "EPL-2.0"
  version_scheme 1
  head "https://github.com/coin-or/CppAD.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "f95f96c70d82b4280878bf8cb148c64334926416700ca86fa87c7914401a3fe3"
    sha256 cellar: :any,                 big_sur:       "eab7dd0a3f58038b0155a5df0c2fa8a5c9e39aa7b9857c8a5ec47015361ec704"
    sha256 cellar: :any,                 catalina:      "dd91794216d8f4a4220fb1d475c8f95a5b57aa00bcf8302dd230610413b8598a"
    sha256 cellar: :any,                 mojave:        "9d2e240bec486c5c9a91a65ef3acda2dd4e4d8da646b7b03977b37e0ba53d9bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f6e37e769d4f36dbff28349e8bffd60f0bad8b857f0761e17417f142d3dd85d0"
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
