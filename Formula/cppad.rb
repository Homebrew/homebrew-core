class Cppad < Formula
  desc "Differentiation of C++ Algorithms"
  homepage "https://www.coin-or.org/CppAD"
  # Stable versions have numbers of the form 201x0000.y
  url "https://github.com/coin-or/CppAD/archive/20170000.8.tar.gz"
  sha256 "195ed02970b06e8b9546ffe198e662dabdaf56f262d11fbdf6fdc9cf77a3e011"
  version_scheme 1
  head "https://github.com/coin-or/CppAD.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "340b46441aaa2b6e42397a4bd544b48bf5bf27a7323d93d841ce80ead80ab1ee" => :high_sierra
    sha256 "340b46441aaa2b6e42397a4bd544b48bf5bf27a7323d93d841ce80ead80ab1ee" => :sierra
    sha256 "340b46441aaa2b6e42397a4bd544b48bf5bf27a7323d93d841ce80ead80ab1ee" => :el_capitan
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args,
                      "-Dcppad_prefix=#{prefix}"
      system "make", "install"
    end
    pkgshare.install "example"
  end

  test do
    (testpath/"test.cpp").write <<-EOS
      #include <cassert>
      #include <cppad/utility/thread_alloc.hpp>

      int main(void) {
        extern bool acos(void);
        bool ok = acos();
        assert(ok);
        return static_cast<int>(!ok);
      }
    EOS

    system ENV.cxx, "#{pkgshare}/example/acos.cpp", "-I#{include}",
                    "test.cpp", "-o", "test"
    system "./test"
  end
end
