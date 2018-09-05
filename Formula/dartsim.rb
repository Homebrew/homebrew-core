class Dartsim < Formula
  desc "Dynamic Animation and Robotics Toolkit"
  homepage "https://dartsim.github.io/"
  url "https://github.com/dartsim/dart/archive/v6.6.1.tar.gz"
  sha256 "86cc3249938602754f773e0843f415c290bd2608729ab3e219de78f90bdd4d6b"
  revision 2

  bottle do
    sha256 "d15af7454c4e2bdf0323fdf6731164748b6c57c295ee346d51059f234d95586f" => :high_sierra
    sha256 "57925e31a3c9365779c2976b97d34b471d082999a56d61c95e8f1253ee7318ba" => :sierra
    sha256 "7e9e02b116f1341cc01889e94b8d0a341cb05852b370d3ee2a4c7e06c59e8ba9" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "assimp"
  depends_on "boost"
  depends_on "bullet"
  depends_on "eigen"
  depends_on "fcl"
  depends_on "flann"
  depends_on "libccd"
  depends_on "nlopt"
  depends_on "ode"
  depends_on "open-scene-graph"
  depends_on "tinyxml2"
  depends_on "urdfdom"

  needs :cxx11

  def install
    ENV.cxx11

    # Force to link to system GLUT (see: https://cmake.org/Bug/view.php?id=16045)
    system "cmake", ".", "-DGLUT_glut_LIBRARY=/System/Library/Frameworks/GLUT.framework",
                         *std_cmake_args
    system "make", "install"

    # Avoid revision bumps whenever fcl's or libccd's Cellar paths change
    inreplace share/"dart/cmake/dart_dartTargets.cmake" do |s|
      s.gsub! Formula["fcl"].prefix.realpath, Formula["fcl"].opt_prefix
      s.gsub! Formula["libccd"].prefix.realpath, Formula["libccd"].opt_prefix
    end

    # Avoid revision bumps whenever urdfdom's or urdfdom_headers's Cellar paths change
    inreplace share/"dart/cmake/dart_utils-urdfTargets.cmake" do |s|
      s.gsub! Formula["urdfdom"].prefix.realpath, Formula["urdfdom"].opt_prefix
      s.gsub! Formula["urdfdom_headers"].prefix.realpath, Formula["urdfdom_headers"].opt_prefix
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <dart/dart.hpp>
      int main() {
        auto world = std::make_shared<dart::simulation::World>();
        assert(world != nullptr);
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-I#{Formula["eigen"].include}/eigen3",
                    "-I#{include}", "-L#{lib}", "-ldart",
                    "-lassimp", "-lboost_system", "-std=c++11", "-o", "test"
    system "./test"
  end
end
