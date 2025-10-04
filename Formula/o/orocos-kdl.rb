class OrocosKdl < Formula
  desc "Orocos Kinematics and Dynamics C++ library"
  homepage "https://orocos.org/"
  url "https://github.com/orocos/orocos_kinematics_dynamics/archive/refs/tags/1.5.2.tar.gz"
  sha256 "dafbfdb68a5ecbf35c0d7ce35d66aa55f3be28e5771617d2af0292df6cdb0092"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2c0ce3eb5d48dcf9712249f89b5747e94acbd5c189738f0f8e3151769e2abfea"
    sha256 cellar: :any,                 arm64_sequoia: "116f8df170aef26b9cd5c82801d054100d8b42197d450e154f2f877bf38879cf"
    sha256 cellar: :any,                 arm64_sonoma:  "85feac97994cc54fea4c1b2852f4ef71784b5c57dacd3064ff256543f5b03fd1"
    sha256 cellar: :any,                 sonoma:        "138ef6ab746ef9853a9cdec458ad74684e65d1cbd3c393cf1009ad11cdc286d9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9d560b8f454e3fa4f3b69ea30a6bb8b8fc536ec79fd8bf1dd98779677c840a08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1174d96445d7d99fefa5d063c4bc20bf985bf2060bad773d0e6f0efb3d3a7e83"
  end

  depends_on "cmake" => :build
  depends_on "eigen"

  def install
    ENV.cxx11
    system "cmake", "-S", "orocos_kdl", "-B", "build",
                    "-DEIGEN3_INCLUDE_DIR=#{Formula["eigen"].opt_include}/eigen3",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <kdl/frames.hpp>
      int main()
      {
        using namespace KDL;
        Vector v1(1.,0.,1.);
        Vector v2(1.,0.,1.);
        assert(v1==v2);
        return 0;
      }
    CPP

    system ENV.cxx, "test.cpp", "-std=c++11", "-I#{include}", "-L#{lib}", "-lorocos-kdl",
                    "-o", "test"
    system "./test"
  end
end
