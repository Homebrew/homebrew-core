class Caf < Formula
  # Renamed from libccpa
  desc "Implementation of the Actor Model for C++"
  homepage "https://www.actor-framework.org/"
  url "https://github.com/actor-framework/actor-framework/archive/0.18.7.tar.gz"
  sha256 "d5c3abe8fd67a729aab1baeece10367637d903ba335f4c79378bcadfbcd34552"
  license "BSD-3-Clause"
  head "https://github.com/actor-framework/actor-framework.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d26e545beda6dc74ee4d446bec12bb54158da2486b4de6dd310f714956a11fad"
    sha256 cellar: :any,                 arm64_monterey: "3c4a2c1e0ec69fb4b6df1173c0424ab17a96a9b40c2d617e23c8ef4a5948f7c2"
    sha256 cellar: :any,                 arm64_big_sur:  "9ad6df11587acfd3dee17c6146c5583c622a93b56fa1196556b78bfbecab19a6"
    sha256 cellar: :any,                 ventura:        "450da6cb21242c11530f54acd2cea1165b7cce5f6752adc6f8be6a90520834a3"
    sha256 cellar: :any,                 monterey:       "b4ac549e53de30f23d33aed19034551b2ae04d71b7522fa499f59f1f426c67ab"
    sha256 cellar: :any,                 big_sur:        "29780a541e8752ac4b6ffd6fac30134f0471b3902a04ecd0bf8533592cd3cf1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "401b400c28bb3d355ba77b67dbe73041b01e3d3ec44cc20937351360a94fa443"
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
