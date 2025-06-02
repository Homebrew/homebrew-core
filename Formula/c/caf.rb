class Caf < Formula
  # Renamed from libccpa
  desc "Implementation of the Actor Model for C++"
  homepage "https://www.actor-framework.org/"
  url "https://github.com/actor-framework/actor-framework/archive/refs/tags/1.0.2.tar.gz"
  sha256 "ef4dd00ca7c59cd61dc336b6a8efbd6150ca85c404d213ecb61f6bcee4094ffc"
  license "BSD-3-Clause"
  head "https://github.com/actor-framework/actor-framework.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9537e004e941d95aac0be101fdb15af8482210717eec4ff76dcb467837cbbe18"
    sha256 cellar: :any,                 arm64_sonoma:  "4b8e61e0a9dba95d2b2894b31a370cddacfc030bd1ac9d8876fa3c80e9ed88c6"
    sha256 cellar: :any,                 arm64_ventura: "acbf088b4337573a0710635d25ae8bb4828a8913b552443206b1c92ed0a555cc"
    sha256 cellar: :any,                 sonoma:        "418ac2c0d3b64145b22f801ba4868490d9306babce62ce2e315da9ccf4b8228d"
    sha256 cellar: :any,                 ventura:       "0d94e1fd5b0d827b48ae36871873a7f574635ca36256616912bfc1a3f02b390a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "678ca206b7bbb125aaf83dd4cacc878c720379a8a38a6372cb6a3b5834e2cf34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "891cd444eefd7ff0c2ca32273b9d7734a43a33f6758b343a126dfb99a8006b3d"
  end

  depends_on "cmake" => :build
  depends_on "openssl@3"

  def install
    tools = pkgshare/"tools"
    rpaths = [rpath, rpath(source: tools)]
    args = ["-DCAF_ENABLE_TESTING=OFF", "-DCMAKE_INSTALL_RPATH=#{rpaths.join(";")}"]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <iostream>
      #include <caf/all.hpp>
      using namespace caf;
      void caf_main(actor_system& system) {
        scoped_actor self{system};
        self->spawn([] {
          std::cout << "test" << std::endl;
        });
      }
      CAF_MAIN()
    CPP
    system ENV.cxx, "-std=c++17", "test.cpp", "-L#{lib}", "-lcaf_core", "-o", "test"
    system "./test"
  end
end
