class Caf < Formula
  # Renamed from libccpa
  desc "Implementation of the Actor Model for C++"
  homepage "https://www.actor-framework.org/"
  url "https://github.com/actor-framework/actor-framework/archive/refs/tags/1.1.0.tar.gz"
  sha256 "9febd85d3a4f50dac760592043028a36bea62bba50c3ee2fc1eace954dd8ae27"
  license "BSD-3-Clause"
  head "https://github.com/actor-framework/actor-framework.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "faa09c3ddebe8332936b1cc01028494b75a7b80763b045256840983be78f3785"
    sha256 cellar: :any,                 arm64_sequoia: "7678c03ac5833969bc5ef720b398e774d1e3156d268d34ce9d95349e7f885823"
    sha256 cellar: :any,                 arm64_sonoma:  "34839f1a22902b556f3ece25edc7e1b3123768f17ed76f2a0e5a24ae0f13110b"
    sha256 cellar: :any,                 arm64_ventura: "c2b9cac897daf44e7c17dcf6b52790a4ed3b74d36a96b61f1794bf3077be02df"
    sha256 cellar: :any,                 sonoma:        "aa3ca3370d07b8ed67d9e319eccf4412e8b7cd8a654eadd8df8fbf1f2c2feff3"
    sha256 cellar: :any,                 ventura:       "967061c8c7b2f3b6adc948623502333c7d680616a6fe21941374aba7f836ae01"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "980f1e6bf7b3462f90c1251a2fc22ca9cdee8f81e1ae631fd34cdd48469aad7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "18dd86732ab832bc6b035af48f3fcc8d05c6ec4dca5ec068d09f43fc3b724335"
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
