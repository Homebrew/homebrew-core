class OrocosKdl < Formula
  desc "Orocos Kinematics and Dynamics C++ library"
  homepage "http://www.orocos.org/kdl"
  url "https://github.com/orocos/orocos_kinematics_dynamics/archive/v1.3.1.tar.gz"
  sha256 "aff361d2b4e2c6d30ae959308a124022eeef5dc5bea2ce779900f9b36b0537bd"

  bottle do
    cellar :any
    sha256 "16245deef22a33a5a016eab85909ed7f5009cab563ee7d9efb33478a1520b52c" => :high_sierra
    sha256 "b52666692aa6d28265454495d96638c6e3774f2de5b28c9d43a548070abaa0c6" => :sierra
    sha256 "b83bf847ccc4417f990252b1452b3c3a77bfe7358f54c4b69a036267db99d3ee" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "eigen"

  def install
    cd "orocos_kdl" do
      system "cmake", ".", "-DEIGEN3_INCLUDE_DIR=#{Formula["eigen"].opt_include}/eigen3",
                           *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <kdl/frames.hpp>
      int main()
      {
        using namespace KDL;
        Vector v1(1.,0.,1.);
        Vector v2(1.,0.,1.);
        assert(v1==v2);
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-I#{include}", "-L#{lib}", "-lorocos-kdl",
                    "-o", "test"
    system "./test"
  end
end
