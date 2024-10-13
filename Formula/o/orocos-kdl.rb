class OrocosKdl < Formula
  desc "Orocos Kinematics and Dynamics C++ library"
  homepage "https://orocos.org/"
  url "https://github.com/orocos/orocos_kinematics_dynamics/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "5acb90acd82b10971717aca6c17874390762ecdaa3a8e4db04984ea1d4a2af9b"
  license "LGPL-2.1-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia:  "56fb6d1bb7796ec39b73f9a1cd8da6f9f946549e90517b526139761bfbd2f820"
    sha256 cellar: :any,                 arm64_sonoma:   "1f64cef75b8d38a0f735e2e173b8fbfe1eaec26519bfee0f05ee5be52e0fd26e"
    sha256 cellar: :any,                 arm64_ventura:  "819c0a9c91a7572f68752d59feb7af82a9b91426d8cd7c14f1614a353f0e7a6e"
    sha256 cellar: :any,                 arm64_monterey: "5b68c4676de398ade876c5c31510527a2b77be2c4b5cb992f5a8beb208d89d52"
    sha256 cellar: :any,                 arm64_big_sur:  "75fc67af57edc2045d8932d1e3cea5b07ac3dfb4c9bbf9632def9c44e769635a"
    sha256 cellar: :any,                 sonoma:         "b73b649ea45a3e8c44dff9cbbc7577e0c5e4e1d9ca2753e85b6df42eb38b4829"
    sha256 cellar: :any,                 ventura:        "b06f4e556b6818d26b38fa070cc9aa704459ce3fe4525f3d530ace039d0338a1"
    sha256 cellar: :any,                 monterey:       "0f49e657e15966fbd854e659a570141eb3f86028074eba50f90a3d0f66cf5d5e"
    sha256 cellar: :any,                 big_sur:        "e7a5a2769dcbf1645d7f2daaf2d3814d4ee80497683ff18fd12196732f0135f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4992170c0dd7c7076a2bcbcc760518d2c815b2f918e7b1abcabf21c712f1c544"
  end

  depends_on "cmake" => :build
  depends_on "eigen"

  # $(brew --prefix orocos-kdl)/share/orocos_kdl/cmake/OrocosKDLTargets.cmake does not export the includes
  # orocos-kdl v1.5.1 was released in September 2021: https://github.com/orocos/orocos_kinematics_dynamics/commit/db25b7e480e068df068232064f2443b8d52a83c7
  # Issue was solved in October 2021: https://github.com/orocos/orocos_kinematics_dynamics/commit/ef39a4fd5cfb1400b2e6e034b1a99b8ad91192cf
  # No new release since then, so we should provide a hotfix.
  # Can be removed with next release.
  patch do
    url "https://github.com/orocos/orocos_kinematics_dynamics/commit/ef39a4fd5cfb1400b2e6e034b1a99b8ad91192cf.patch?full_index=1"
    sha256 "b2ac2ff5d5d3285e7dfb4fbfc81364b1abc808cdd7d22415e446bfbdca189edd"
  end

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
