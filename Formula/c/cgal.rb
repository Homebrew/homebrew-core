class Cgal < Formula
  desc "Computational Geometry Algorithms Library"
  homepage "https://www.cgal.org/"
  url "https://github.com/CGAL/cgal/releases/download/v6.0.1/CGAL-6.0.1.tar.xz"
  sha256 "0acdfbf317c556630dd526f3253780f29b6ec9713ee92903e81b5c93c0f59b7f"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f423b392b99b69eff16bdad8309eebfa1e01ef6e569c6c2b50fd20e2fafeab7d"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "qt" => :test
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

    # Ensure that the various `Find*` modules look in HOMEBREW_PREFIX.
    # This also helps guarantee uniform bottles.
    inreplace_files = %w[
      CGAL_Common.cmake
      FindESBTL.cmake
      FindGLPK.cmake
      FindIPE.cmake
      FindLASLIB.cmake
      FindMKL.cmake
      FindOSQP.cmake
      FindSuiteSparse.cmake
    ]
    inreplace inreplace_files.map { |file| lib/"cmake/CGAL"/file }, "/usr/local", HOMEBREW_PREFIX

    # These cause different bottles to be built between macOS and Linux for some reason.
    %w[README.md readme.md].each { |file| (buildpath/file).unlink if (buildpath/file).exist? }
  end

  test do
    # https://doc.cgal.org/latest/Triangulation_2/Triangulation_2_2draw_triangulation_2_8cpp-example.html and  https://doc.cgal.org/latest/Algebraic_foundations/Algebraic_foundations_2interoperable_8cpp-example.html
    (testpath/"surprise.cpp").write <<~CPP
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
      cmake_minimum_required(VERSION 3.1...3.15)
      find_package(CGAL COMPONENTS Qt6)
      add_definitions(-DCGAL_USE_BASIC_VIEWER -DQT_NO_KEYWORDS)
      include_directories(surprise BEFORE SYSTEM #{Formula["qt"].opt_include})
      add_executable(surprise surprise.cpp)
      target_include_directories(surprise BEFORE PUBLIC #{Formula["qt"].opt_include})
      target_link_libraries(surprise PUBLIC CGAL::CGAL_Qt6)
    CMAKE
    system "cmake", "-L", "-DQt6_DIR=#{Formula["qt"].opt_lib}/cmake/Qt6",
           "-DCMAKE_PREFIX_PATH=#{Formula["qt"].opt_lib}",
           "-DCMAKE_BUILD_RPATH=#{HOMEBREW_PREFIX}/lib", "-DCMAKE_PREFIX_PATH=#{prefix}", "."
    system "cmake", "--build", ".", "-v"
    assert_equal "15\n15", shell_output("./surprise").chomp
  end
end
