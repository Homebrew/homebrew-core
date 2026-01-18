class OrocosKdl < Formula
  desc "Orocos Kinematics and Dynamics C++ library"
  homepage "https://orocos.org/"
  url "https://github.com/orocos/orocos_kinematics_dynamics/archive/refs/tags/1.5.3.tar.gz"
  sha256 "3895eed1b51a6803c79e7ac4acd6a2243d621b887ac26a1a6b82a86a1131c3b6"
  license "LGPL-2.1-or-later"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f426120fbf55e9662b30801031021f06f97de8dceb6fa2b191767868e858f411"
    sha256 cellar: :any,                 arm64_sequoia: "731dac44439182078ff405304de91785dd85c8c63ccdb9ace10b6c6892755b9a"
    sha256 cellar: :any,                 arm64_sonoma:  "1e89c7a3075cb09bc42a48dac3e0615c3fb247610e47a1fed9b4ba16452523a7"
    sha256 cellar: :any,                 tahoe:         "b3452bee349dfa41da18a7c9f3df3343561702441e13befe4f879bc4359c679e"
    sha256 cellar: :any,                 sequoia:       "7c12c1c4509464c389d04d0a273e40d09e44da3df366ba5e889dc0051fa9823f"
    sha256 cellar: :any,                 sonoma:        "c422791098d548a20a16a386b03514b3efddd1e4646804932559a98023ffd9f5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e0d188d3d5f65a19ecdd37d5a39d194177d341b70f755d7b8fb1459a59723fcd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b9fe98f805b5c9c3944a6288a5a3abdc262ee58755d259fbeb11f04571e30dc"
  end

  depends_on "cmake" => :build
  depends_on "eigen"

  def install
    system "cmake", "-S", "orocos_kdl", "-B", "build",
                    "-DCMAKE_CXX_STANDARD=14",
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

    system ENV.cxx, "test.cpp", "-std=c++14", "-I#{include}", "-L#{lib}", "-lorocos-kdl",
                    "-o", "test"
    system "./test"
  end
end
