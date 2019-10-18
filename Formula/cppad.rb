class Cppad < Formula
  desc "Differentiation of C++ Algorithms"
  homepage "https://www.coin-or.org/CppAD"
  # Stable versions have numbers of the form 201x0000.y
  url "https://github.com/coin-or/CppAD/archive/20190200.3.tar.gz"
  sha256 "5e074ddfe1e022347c32dddfdf72f2d14bff25ab29448c65c15c5ed1b459dbcc"
  version_scheme 1
  head "https://github.com/coin-or/CppAD.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "08a61ed522403b739b273f6db5f937ca7683d68d1fdb8e105875a3a5cb40b6c7" => :catalina
    sha256 "eae636ccddbcbef3cc751f7c4759ae004631e91eacbef1f050facd0c1b72bf47" => :mojave
    sha256 "eae636ccddbcbef3cc751f7c4759ae004631e91eacbef1f050facd0c1b72bf47" => :high_sierra
    sha256 "62a4325bd142603730bee7beb52af62fdb5a757895035fd51fc8f63ebec78648" => :sierra
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

    system ENV.cxx, "#{pkgshare}/example/general/acos.cpp", "-I#{include}",
                    "test.cpp", "-o", "test"
    system "./test"
  end
end
