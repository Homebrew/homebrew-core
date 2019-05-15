class Cgal < Formula
  desc "Computational Geometry Algorithm Library"
  homepage "https://www.cgal.org/"
  url "https://github.com/CGAL/cgal/releases/download/releases%2FCGAL-4.14/CGAL-4.14.tar.xz"
  sha256 "59464b1eaee892f2223ba570a7642892c999e29524ab102a6efd7c29c94a29f7"

  bottle do
    cellar :any
    sha256 "8987fe56d173560be950ee0bbe77c5a7a5015b743c1111cb5136946b86af92e1" => :mojave
    sha256 "9ebc1fcc1954264abed37bb40cff0d64f6290b03effa0d95e4b579c9710a4f59" => :high_sierra
    sha256 "13eb7618b3f053926d6f88e4d701a12bc4792b1aabad0f822b1af9c1a51ea242" => :sierra
  end

  depends_on "cmake" => [:build, :test]
  depends_on "boost"
  depends_on "eigen"
  depends_on "gmp"
  depends_on "mpfr"

  def install
    args = std_cmake_args + %W[
      -DCMAKE_BUILD_WITH_INSTALL_RPATH=ON
      -DCMAKE_INSTALL_NAME_DIR=#{HOMEBREW_PREFIX}/lib
      -DWITH_Eigen3=ON
      -DWITH_LAPACK=ON
      -DWITH_CGAL_Qt5=OFF
      -DWITH_CGAL_ImageIO=OFF
    ]
    system "cmake", ".", *args
    system "make", "install"
  end

  test do
    # https://doc.cgal.org/latest/Algebraic_foundations/Algebraic_foundations_2interoperable_8cpp-example.html
    (testpath/"surprise.cpp").write <<~EOS
      #include <CGAL/basic.h>
      #include <CGAL/Coercion_traits.h>
      #include <CGAL/IO/io.h>
      template <typename A, typename B>
      typename CGAL::Coercion_traits<A,B>::Type
      binary_func(const A& a , const B& b){
          typedef CGAL::Coercion_traits<A,B> CT;
          CGAL_static_assertion((CT::Are_explicit_interoperable::value));
          typename CT::Cast cast;
          return cast(a)*cast(b);
      }
      int main(){
          std::cout<< binary_func(double(3), int(5)) << std::endl;
          std::cout<< binary_func(int(3), double(5)) << std::endl;
          return 0;
      }
    EOS
    (testpath/"CMakeLists.txt").write <<~EOS
      cmake_minimum_required(VERSION 3.1...3.13)
      find_package(CGAL)
      add_executable(surprise surprise.cpp)
      target_link_libraries(surprise PRIVATE CGAL::CGAL)
    EOS
    system "cmake", "-L", "-DCMAKE_BUILD_RPATH=#{HOMEBREW_PREFIX}/lib", "-DCMAKE_PREFIX_PATH=#{prefix}", "."
    system "cmake", "--build", ".", "-v"
    assert_equal "15\n15", shell_output("./surprise").chomp
  end
end
