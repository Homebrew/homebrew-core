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
    sha256 cellar: :any,                 arm64_big_sur: "8a7a1f1f68d98a89d466c02096464d8092be04507be2382b34a568733c97dd78"
    sha256 cellar: :any,                 big_sur:       "557acdd155bb802f9e9c2a4eec1dd3e269874f8d9cd371127608c0f6b7e6ec6b"
    sha256 cellar: :any,                 catalina:      "82e4a9a298f22f5ab0499df641591ddae39cb710dfe6e78ee8a2f52d5dd7f700"
    sha256 cellar: :any,                 mojave:        "7a413468750c211a29ccc4d48b911aa36d620ea91aa1be1ec155d520375f0445"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d6548f67760ee32ee5687c8039af8053b5a4d3c1e45dbc641c02342a8c289f65"
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
