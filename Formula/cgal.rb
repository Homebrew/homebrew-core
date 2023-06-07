class Cgal < Formula
  desc "Computational Geometry Algorithms Library"
  homepage "https://www.cgal.org/"
  url "https://github.com/CGAL/cgal/releases/download/v5.5.2/CGAL-5.5.2.tar.xz"
  sha256 "b2b05d5616ecc69facdc24417cce0b04fb4321491d107db45103add520e3d8c3"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dac91a0004bad87169513d3df69586fd42c3ad4586a2158cdc8aba2c520a6171"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dac91a0004bad87169513d3df69586fd42c3ad4586a2158cdc8aba2c520a6171"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dac91a0004bad87169513d3df69586fd42c3ad4586a2158cdc8aba2c520a6171"
    sha256 cellar: :any_skip_relocation, ventura:        "ded5db67baf3074c283561e9a258a0141285b8b41bc38d16405e4eceeb7d73aa"
    sha256 cellar: :any_skip_relocation, monterey:       "ded5db67baf3074c283561e9a258a0141285b8b41bc38d16405e4eceeb7d73aa"
    sha256 cellar: :any_skip_relocation, big_sur:        "ded5db67baf3074c283561e9a258a0141285b8b41bc38d16405e4eceeb7d73aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dac91a0004bad87169513d3df69586fd42c3ad4586a2158cdc8aba2c520a6171"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "qt@5" => [:build, :test]
  depends_on "boost"
  depends_on "eigen"
  depends_on "gmp"
  depends_on "mpfr"

  on_linux do
    depends_on "openssl@3"
  end

  fails_with gcc: "5"

  def install
    args = std_cmake_args + %w[
      -DCMAKE_CXX_FLAGS='-std=c++14'
      -DWITH_CGAL_Qt5=ON
    ]

    system "cmake", ".", *args
    system "make", "install"
  end

  test do
    # https://doc.cgal.org/latest/Triangulation_2/Triangulation_2_2draw_triangulation_2_8cpp-example.html and  https://doc.cgal.org/latest/Algebraic_foundations/Algebraic_foundations_2interoperable_8cpp-example.html
    (testpath/"surprise.cpp").write <<~EOS
      #include <CGAL/Exact_predicates_inexact_constructions_kernel.h>
      #include <CGAL/Triangulation_2.h>
      #include <CGAL/draw_triangulation_2.h>
      #include <CGAL/basic.h>
      #include <CGAL/Coercion_traits.h>
      #include <CGAL/IO/io.h>
      #include <fstream>
      typedef CGAL::Exact_predicates_inexact_constructions_kernel K;
      typedef CGAL::Triangulation_2<K>                            Triangulation;
      typedef Triangulation::Point                                Point;

      template <typename A, typename B>
      typename CGAL::Coercion_traits<A,B>::Type
      binary_func(const A& a , const B& b){
          typedef CGAL::Coercion_traits<A,B> CT;
          CGAL_static_assertion((CT::Are_explicit_interoperable::value));
          typename CT::Cast cast;
          return cast(a)*cast(b);
      }

      int main(int argc, char**) {
        std::cout<< binary_func(double(3), int(5)) << std::endl;
        std::cout<< binary_func(int(3), double(5)) << std::endl;
        std::ifstream in("data/triangulation_prog1.cin");
        std::istream_iterator<Point> begin(in);
        std::istream_iterator<Point> end;
        Triangulation t;
        t.insert(begin, end);
        if(argc == 3) // do not test Qt5 at runtime
          CGAL::draw(t);
        return EXIT_SUCCESS;
       }
    EOS
    (testpath/"CMakeLists.txt").write <<~EOS
      cmake_minimum_required(VERSION 3.1...3.15)
      find_package(CGAL COMPONENTS Qt5)
      add_definitions(-DCGAL_USE_BASIC_VIEWER -DQT_NO_KEYWORDS)
      include_directories(surprise BEFORE SYSTEM #{Formula["qt@5"].opt_include})
      add_executable(surprise surprise.cpp)
      target_include_directories(surprise BEFORE PUBLIC #{Formula["qt@5"].opt_include})
      target_link_libraries(surprise PUBLIC CGAL::CGAL_Qt5)
    EOS
    system "cmake", "-L", "-DQt5_DIR=#{Formula["qt@5"].opt_lib}/cmake/Qt5",
           "-DCMAKE_PREFIX_PATH=#{Formula["qt@5"].opt_lib}",
           "-DCMAKE_BUILD_RPATH=#{HOMEBREW_PREFIX}/lib", "-DCMAKE_PREFIX_PATH=#{prefix}", "."
    system "cmake", "--build", ".", "-v"
    assert_equal "15\n15", shell_output("./surprise").chomp
  end
end
