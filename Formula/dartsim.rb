class Dartsim < Formula
  desc "Dynamic Animation and Robotics Toolkit"
  homepage "https://dartsim.github.io/"
  url "https://github.com/dartsim/dart/archive/v6.5.0.tar.gz"
  sha256 "b4c7f4d800ae5696e6ada04bd91b299f4a5e4ff9e8e07deeed79c6923747e274"
  revision 2

  bottle do
    sha256 "92be7a73b58ee7e90dd8556eb040527d3902bc7f96f074c240f1a2f7340b2e2e" => :high_sierra
    sha256 "535bf09f0b7bc6145ee9a582acf9cace765c631273b54c022a5e7ccaeb65e936" => :sierra
    sha256 "6437c45476c48b2a7b7c2a94166cdce72e85c4756c2110fc164912faf6aad776" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "assimp"
  depends_on "boost"
  depends_on "bullet"
  depends_on "eigen"
  depends_on "fcl"
  depends_on "flann"
  depends_on "freeglut"
  depends_on "libccd"
  depends_on "nlopt"
  depends_on "ode"
  depends_on "open-scene-graph"
  depends_on "tinyxml2"
  depends_on "urdfdom"

  needs :cxx11

  def install
    ENV.cxx11
    system "cmake", ".", *std_cmake_args
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
