class Cgal < Formula
  desc "Computational Geometry Algorithm Library"
  homepage "https://www.cgal.org/"
  url "https://github.com/CGAL/cgal/releases/download/releases%2FCGAL-4.13/CGAL-4.13.tar.xz"
  sha256 "3e3dd7a64febda58be54c3cbeba329ab6a73b72d4d7647ba4931ecd1fad0e3bc"

  bottle do
    cellar :any
    sha256 "c8645dcc07c0c2be479d8521a835b824cc25a05a3be3857c8ab3c2240af265b3" => :mojave
    sha256 "4996b3af224bece9348288878c47f4b1a6de780311c711a044ed85ee25b21d47" => :high_sierra
    sha256 "b21b64f5f7806d599edf51dc030ec367aa420160d505e6ba8abb1752bacc9321" => :sierra
    sha256 "ccbaa0179fe268ce00bb467759c29e626ff606b537963a6ee099980789c9f519" => :el_capitan
  end

  option "with-qt", "Build ImageIO and Qt components of CGAL"

  deprecated_option "imaging" => "with-qt"
  deprecated_option "with-imaging" => "with-qt"
  deprecated_option "with-qt5" => "with-qt"

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "eigen"
  depends_on "gmp"
  depends_on "mpfr"
  depends_on "qt" => :optional

  def install
    args = std_cmake_args + %W[
      -DCMAKE_BUILD_WITH_INSTALL_RPATH=ON
      -DCMAKE_INSTALL_NAME_DIR=#{HOMEBREW_PREFIX}/lib
      -DWITH_Eigen3=ON
      -DWITH_LAPACK=ON
    ]

    if build.without? "qt"
      args << "-DWITH_CGAL_Qt5=OFF" << "-DWITH_CGAL_ImageIO=OFF"
    else
      args << "-DWITH_CGAL_Qt5=ON" << "-DWITH_CGAL_ImageIO=ON"
    end

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
    system ENV.cxx, "-I#{include}", "-L#{lib}", "-lCGAL",
                    "surprise.cpp", "-o", "test"
    assert_equal "15\n15", shell_output("./test").chomp
  end
end
