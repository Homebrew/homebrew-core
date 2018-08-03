class Dartsim < Formula
  desc "Dynamic Animation and Robotics Toolkit"
  homepage "https://dartsim.github.io/"
  url "https://github.com/dartsim/dart/archive/v6.6.0.tar.gz"
  sha256 "c0146f7da1b3367c1e2178f45e42bfed553a26cf085db815cb7ef96032bdac1f"

  bottle do
    sha256 "dff5015b2b39c13910b7e66fe8cf649a87d95e7fc0ad196ba68d93592c006b44" => :high_sierra
    sha256 "acf9f646a804e0a13802faefd0fed73122be1f400391ad8821f620249c56254b" => :sierra
    sha256 "e6f03a9eb31f5735e13c4e2687aa6d9810e4feecf9c56fa0fb183d32b3789561" => :el_capitan
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
