class Caf < Formula
  # Renamed from libccpa
  desc "Implementation of the Actor Model for C++"
  homepage "https://www.actor-framework.org/"
  url "https://github.com/actor-framework/actor-framework/archive/refs/tags/1.1.0.tar.gz"
  sha256 "9febd85d3a4f50dac760592043028a36bea62bba50c3ee2fc1eace954dd8ae27"
  license "BSD-3-Clause"
  head "https://github.com/actor-framework/actor-framework.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "cdea98fe4c1d6c96ce9c27d279bbbd9c27bb201be0c7d3962d13a4a5ea544eb4"
    sha256 cellar: :any,                 arm64_sequoia: "8feab93e8b57d114236e22652bed925c45a0c99d5973c9156b12bd8252b0f95c"
    sha256 cellar: :any,                 arm64_sonoma:  "0e1a5cdca6696088cc37f12d0908abf669655689e6187066994eb022814905e8"
    sha256 cellar: :any,                 sonoma:        "66f289a4e6565895a7dce5c54560496b541944792a8bdba92742276371f43b17"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5be578ceca56236f6383d890131db23cd0c113e57d090866a4e85231bd7ac2dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "308c700f475a619ae55aec7ce2952dce2db3df85ea38ecc8a8067f6365ca1dd7"
  end

  depends_on "cmake" => :build
  depends_on "openssl@4"

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
