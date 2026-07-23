class Cgal < Formula
  desc "Computational Geometry Algorithms Library"
  homepage "https://www.cgal.org/"
  url "https://github.com/CGAL/cgal/releases/download/v6.2/CGAL-6.2.tar.xz"
  sha256 "fbc32816745e871a5cbdeb6245317e9dbf10ae1a957b0ab1edb00b4fde00ba8d"
  license "GPL-3.0-or-later"
  compatibility_version 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "dbe2a9a20e71d785f684a9bdaa194887116b960454150d26c33e20071ac191cd"
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

  # Backport fix for .debug_gdb_scripts section to avoid errors on some linkers
  patch :p2 do
    url "https://github.com/CGAL/cgal/commit/eb2257df4da4c52c75fe384e803d9a6376057b8a.patch?full_index=1"
    sha256 "2686aea78dc3a58180eb1744dea44f27bd4d692ae8cfc9a4fab2a616fd6b7535"
    type :backport
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
