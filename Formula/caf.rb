class Caf < Formula
  # Renamed from libccpa
  desc "Implementation of the Actor Model for C++"
  homepage "https://www.actor-framework.org/"
  url "https://github.com/actor-framework/actor-framework/archive/0.19.1.tar.gz"
  sha256 "8a99ed7c077d815382f833f5c1068a1fcb2e7839b7246e950856e1146a6caf0e"
  license "BSD-3-Clause"
  head "https://github.com/actor-framework/actor-framework.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "361fccf7eadc375dee7d96e9968d73d73326efb1ba9411d1001a325231ba8b9c"
    sha256 cellar: :any,                 arm64_monterey: "8972343770c120ca40274d2d3cadf40c16af8ac91ecf6fe0b9c2c24cbb43c489"
    sha256 cellar: :any,                 arm64_big_sur:  "7a1c570c03d98ef3789274869c6e9652ea50e5233cfff0f37de99e4e938b703f"
    sha256 cellar: :any,                 ventura:        "e713c21e0fef0982b16e167ed97a12ce702e2482f9ec835f9962d3aa50861342"
    sha256 cellar: :any,                 monterey:       "01b84e936f7304983df1647fef39e724107accf022e7f65f4af52ff369e89d6c"
    sha256 cellar: :any,                 big_sur:        "c6f611a8e2014b620e05b130379cfdf4dca54a0c6128cd5aa0759e86172ebe91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "867af95c1522cc685e0127bcf65fec2df7dcbfd89dea844600f83ea5b318ef06"
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
