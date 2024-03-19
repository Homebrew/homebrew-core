class Caf < Formula
  # Renamed from libccpa
  desc "Implementation of the Actor Model for C++"
  homepage "https://www.actor-framework.org/"
  url "https://github.com/actor-framework/actor-framework/archive/refs/tags/0.19.6.tar.gz"
  sha256 "48dc4c4abf5ab5a7c6f84b9259cc8be1b02c601d31893647ab44e143cdc4b6d5"
  license "BSD-3-Clause"
  head "https://github.com/actor-framework/actor-framework.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "5f4f687cb5f7e16d21e1bc428ea3ce722f4fb34947a1439e2799beebfdf78d43"
    sha256 cellar: :any,                 arm64_ventura:  "b9e51260c62dee7a1fd792c52ef6ff977c5dc42d2169e1e2757741bb8cdfab7c"
    sha256 cellar: :any,                 arm64_monterey: "d204562f38a7acd860b71bdcafebceaadf75dddd71995a4ed9df72d59e95b2e4"
    sha256 cellar: :any,                 sonoma:         "251c016b181f8cba05f6366fe28eb6e85dac757ec8b0e4d9fef293f6c02980d6"
    sha256 cellar: :any,                 ventura:        "211a49f431d819f2b8652764b6397b278707e1ff6d6642ee03acf3cfb616b9e7"
    sha256 cellar: :any,                 monterey:       "c5295508f8ef5bdf5dcff3bff9c4710658f5d9694b82b15a4989ea0dd953d00a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "db803ebdc24f1e44baaebda7b899705ab8493f87b3420823a47f0db5e302bb94"
  end

  depends_on "cmake" => :build
  depends_on "openssl@3"

  fails_with gcc: "5"

  def install
    tools = pkgshare/"tools"
    rpaths = [rpath, rpath(source: tools)]
    args = ["-DCAF_ENABLE_TESTING=OFF", "-DCMAKE_INSTALL_RPATH=#{rpaths.join(";")}"]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
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
    EOS
    system ENV.cxx, "-std=c++17", "test.cpp", "-L#{lib}", "-lcaf_core", "-o", "test"
    system "./test"
  end
end
