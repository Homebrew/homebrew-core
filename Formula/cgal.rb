class Cgal < Formula
  desc "Computational Geometry Algorithms Library"
  homepage "https://www.cgal.org/"
  url "https://github.com/CGAL/cgal/releases/download/v5.5.1/CGAL-5.5.1.tar.xz"
  sha256 "091630def028facdcaf00eb5b68ad79eddac1b855cca6e87eef18a031566edfc"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "897f5c47b844d9497988a93992966d7927917e86a12ae91a1f217480bac7727e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "897f5c47b844d9497988a93992966d7927917e86a12ae91a1f217480bac7727e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "897f5c47b844d9497988a93992966d7927917e86a12ae91a1f217480bac7727e"
    sha256 cellar: :any_skip_relocation, ventura:        "f9735a2ec181081f7dd63984266ed8ac97c337a17607c0b20fe25d267893bce8"
    sha256 cellar: :any_skip_relocation, monterey:       "f9735a2ec181081f7dd63984266ed8ac97c337a17607c0b20fe25d267893bce8"
    sha256 cellar: :any_skip_relocation, big_sur:        "f9735a2ec181081f7dd63984266ed8ac97c337a17607c0b20fe25d267893bce8"
    sha256 cellar: :any_skip_relocation, catalina:       "f9735a2ec181081f7dd63984266ed8ac97c337a17607c0b20fe25d267893bce8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "897f5c47b844d9497988a93992966d7927917e86a12ae91a1f217480bac7727e"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "qt@5" => [:build, :test]
  depends_on "boost"
  depends_on "eigen"
  depends_on "gmp"
  depends_on "mpfr"

  on_linux do
    depends_on "openssl@1.1"
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
