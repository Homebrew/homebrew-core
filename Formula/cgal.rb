class Cgal < Formula
  desc "CGAL: Computational Geometry Algorithm Library"
  homepage "https://www.cgal.org/"
  url "https://github.com/CGAL/cgal/releases/download/releases/CGAL-4.9/CGAL-4.9.tar.xz"
  sha256 "63ac5df71f912f34f2f0f2e54a303578df51f4ec2627db593a65407d791f9039"

  bottle do
    cellar :any
    sha256 "07bcb1128539e5045d224d110c058d6c1459cba79a18987cdf2a54cc136c406a" => :sierra
    sha256 "5e717e77ba45eb70a0f9cb705eb26f67519ba4e76f0a4291345c0005a45f086c" => :el_capitan
    sha256 "da91e87aa5c25a671d7a500efa51e1b98e85aae6cdf9a9d325762c344e0a4baf" => :yosemite
    sha256 "27b5b09bbc9bf9f71cbfeff51a23543e699d2a46442085870eaabfab66dc81b3" => :mavericks
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
