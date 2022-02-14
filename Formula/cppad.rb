class Cppad < Formula
  desc "Differentiation of C++ Algorithms"
  homepage "https://www.coin-or.org/CppAD"
  # Stable versions have numbers of the form 201x0000.y
  url "https://github.com/coin-or/CppAD/archive/20220000.2.tar.gz"
  sha256 "a363996d6a36c08b37048d3c439119d1cd715ce7caf124ac6f0c2e94240985bd"
  license "EPL-2.0"
  version_scheme 1
  head "https://github.com/coin-or/CppAD.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "4bf638f87ef91e08200f860e3dd6073e16f653de91637b50b2eab717cf6c0180"
    sha256 cellar: :any,                 arm64_big_sur:  "e8ab2a0462ba2f7a0ce0801e81c65e0cb86ccd73bc39bdc67401edd4784162ec"
    sha256 cellar: :any,                 monterey:       "fa31d5517dbbaeaf87d0db041ab6bb91a0f9c2ffda42091a02aad9083b29ef49"
    sha256 cellar: :any,                 big_sur:        "79db2a1511c61b7d0a7f000bb17088b97d633e21bf0504b8b24f4813a4fd1b1d"
    sha256 cellar: :any,                 catalina:       "adb9ccfaa8aeceb4ff09ef0215f412e03fc404b3a1ffc499a41f0a0a8cb74c06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "93017c4eef160255f23db2a6d7f576ba5a61e6711bc9f997be49700e4d0eb937"
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
