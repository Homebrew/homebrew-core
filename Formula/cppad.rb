class Cppad < Formula
  desc "Differentiation of C++ Algorithms"
  homepage "https://www.coin-or.org/CppAD"
  # Stable versions have numbers of the form 201x0000.y
  url "https://github.com/coin-or/CppAD/archive/20210000.4.tar.gz"
  sha256 "3f260fd850a25a4faa930e01d567d6dd9549677ce0ec152334af4ae66dc3b3f4"
  license "EPL-2.0"
  version_scheme 1
  head "https://github.com/coin-or/CppAD.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "577118fabf3804c109fa22d2f995c3170ae9e319e9d50bd810ba98a38ff285bd"
    sha256 cellar: :any, big_sur:       "bbd9d0e16ee51ec4f9d1b031ee459b815bd1fc059c36246b7cbe69e6177750ca"
    sha256 cellar: :any, catalina:      "dba78015166853249a2ff6467f9dd7fd4e45c7914706ed174e94f31536294549"
    sha256 cellar: :any, mojave:        "28cbc31c7971a99a55d73af33159ccdb6ff0e4902dba0a512065704a30bf5c47"
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
