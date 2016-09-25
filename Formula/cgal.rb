class Cgal < Formula
  desc "CGAL: Computational Geometry Algorithm Library"
  homepage "https://www.cgal.org/"
  url "https://github.com/CGAL/cgal/releases/download/releases/CGAL-4.9/CGAL-4.9.tar.xz"
  sha256 "63ac5df71f912f34f2f0f2e54a303578df51f4ec2627db593a65407d791f9039"

  bottle do
    cellar :any
    sha256 "bc2d75f374a2b7b801a243937553cdaf23c4ec1f3f3cbce0910f0c5357ed7820" => :sierra
    sha256 "1347cfad615b487b11e083e7114ac2e3e0d2fb271cb7a9413ed1531d03c92f1b" => :el_capitan
    sha256 "0014c368e53254801a2a1233424027156e2bdf0c09c12b17246119c8337fd02a" => :yosemite
  end

  option :cxx11
  option "with-qt5", "Build ImageIO and QT5 compoments of CGAL"
  option "with-eigen", "Build with Eigen3 support"
  option "with-lapack", "Build with LAPACK support"

  deprecated_option "imaging" => "with-qt5"
  deprecated_option "with-imaging" => "with-qt5"
  deprecated_option "with-eigen3" => "with-eigen"

  depends_on "cmake" => :build
  depends_on "mpfr"

  depends_on "qt5" => :optional
  depends_on "eigen" => :optional

  if build.cxx11?
    depends_on "boost" => "c++11"
    depends_on "gmp"   => "c++11"
  else
    depends_on "boost"
    depends_on "gmp"
  end

  def install
    ENV.cxx11 if build.cxx11?

    args = std_cmake_args + %W[
      -DCMAKE_BUILD_WITH_INSTALL_RPATH=ON
      -DCMAKE_INSTALL_NAME_DIR=#{HOMEBREW_PREFIX}/lib
    ]

    if build.without? "qt5"
      args << "-DWITH_CGAL_Qt5=OFF" << "-DWITH_CGAL_ImageIO=OFF"
    else
      args << "-DWITH_CGAL_Qt5=ON" << "-DWITH_CGAL_ImageIO=ON"
    end

    if build.with? "eigen"
      args << "-DWITH_Eigen3=ON"
    else
      args << "-DWITH_Eigen3=OFF"
    end

    if build.with? "lapack"
      args << "-DWITH_LAPACK=ON"
    else
      args << "-DWITH_LAPACK=OFF"
    end

    system "cmake", ".", *args
    system "make", "install"
  end

  test do
    # https://doc.cgal.org/latest/Algebraic_foundations/Algebraic_foundations_2interoperable_8cpp-example.html
    (testpath/"surprise.cpp").write <<-EOS.undent
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
    system ENV.cxx, "-I#{include}", "-L#{lib}", "-lCGAL",
                    "surprise.cpp", "-o", "test"
    assert_equal "15\n15", shell_output("./test").chomp
  end
end
