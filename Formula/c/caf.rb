class Caf < Formula
  # Renamed from libccpa
  desc "Implementation of the Actor Model for C++"
  homepage "https://www.actor-framework.org/"
  url "https://github.com/actor-framework/actor-framework/archive/refs/tags/1.2.0.tar.gz"
  sha256 "2e4c5e2f02e0a2cfda0b011b26cf61b436ef206bea0cce235f5ee55e3d6327fb"
  license "BSD-3-Clause"
  head "https://github.com/actor-framework/actor-framework.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "b66ac1ea69dc7ced6e3e58552c38041c8398e3bb283f6a29155afece3e755db7"
    sha256 cellar: :any, arm64_tahoe:       "c60f46aa757ac231b3e43c7a215e0678db8053ab2ef1e34fea168e7a327b1580"
    sha256 cellar: :any, arm64_sequoia:     "a63573dba3ca05be8b524081f41b1691c52a4cc968bd8a4027f6e35b499d2e20"
    sha256 cellar: :any, arm64_linux:       "c84ba5286471211d1e6a2052b26b10c982fc3b61959b21b77c79cc35f542331f"
    sha256 cellar: :any, x86_64_linux:      "52a2d94ee7e4f9ad55abcbf45a37c81e2381d06d3b7f18bebd53447d71cfa7c6"
  end

  depends_on "cmake" => :build
  depends_on "openssl@4"

  deny_network_access!

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
