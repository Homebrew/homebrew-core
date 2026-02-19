class Cgal < Formula
  desc "Computational Geometry Algorithms Library"
  homepage "https://www.cgal.org/"
  url "https://github.com/CGAL/cgal/releases/download/v6.1.1/CGAL-6.1.1.tar.xz"
  sha256 "52506935f70e247ed2777e3c65f20e86f79208c2a2d0e180ae7475daf11c96ef"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "95647d7bbb34bb7cdfe965cfc7d0224faec548a2b044fcf73aa2d815c856cd51"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "qtbase" => :test
  depends_on "boost"
  depends_on "eigen"
  depends_on "gmp"
  depends_on "mpfr"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # These cause different bottles to be built between macOS and Linux for some reason.
    %w[README.md readme.md].each { |file| (buildpath/file).unlink if (buildpath/file).exist? }
  end

  test do
    # https://doc.cgal.org/latest/Triangulation_2/Triangulation_2_2draw_triangulation_2_8cpp-example.html
    # https://doc.cgal.org/latest/Algebraic_foundations/Algebraic_foundations_2interoperable_8cpp-example.html
    (testpath/"surprise.cpp").write <<~CPP
      #include <CGAL/Exact_predicates_inexact_constructions_kernel.h>
      #include <CGAL/Triangulation_2.h>
      #include <CGAL/draw_triangulation_2.h>
      #include <CGAL/basic.h>
      #include <CGAL/Coercion_traits.h>
      #include <CGAL/IO/io.h>
      #include <fstream>

      typedef CGAL::Exact_predicates_inexact_constructions_kernel K;
      typedef CGAL::Triangulation_2<K> Triangulation;
      typedef Triangulation::Point Point;

      template <typename A, typename B>
      typename CGAL::Coercion_traits<A,B>::Type
      binary_func(const A& a , const B& b){
        typedef CGAL::Coercion_traits<A,B> CT;
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
        if(argc == 3) // do not test Qt6 at runtime
          CGAL::draw(t);
        return EXIT_SUCCESS;
       }
    CPP

    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 3.15)
      project(surprise)
      find_package(CGAL COMPONENTS Qt6)
      add_definitions(-DCGAL_USE_BASIC_VIEWER -DQT_NO_KEYWORDS)
      add_executable(surprise surprise.cpp)
      target_link_libraries(surprise PUBLIC CGAL::CGAL_Qt6)
    CMAKE

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    assert_equal "15\n15", shell_output("./build/surprise").chomp
  end
end
