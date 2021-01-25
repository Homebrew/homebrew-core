class Cpr < Formula
  desc "C++ Requests, a spiritual port of Python Requests"
  homepage "https://whoshuu.github.io/cpr/"
  url "https://github.com/whoshuu/cpr.git",
      tag:      "1.5.2",
      revision: "41fbaca90160950f1397e0ffc6b58bd81063f131"
  license "MIT"
  head "https://github.com/whoshuu/cpr.git"

  bottle do
    cellar :any
    sha256 "0f3457ec4a948fb235d26d9bfdd0c1b3f53297c0e7c505a1f34a3d853907ddc8" => :big_sur
    sha256 "b93aecd08cd2c187694a572c2c9c8d4cdb0ed181b4387fd3e7a68f67a4847d6a" => :arm64_big_sur
    sha256 "51bbf276165a820d37e9d9dfc829e7dae6f100b57bbb4095283955924027a7e8" => :catalina
    sha256 "66cfe69826f724c686417117ba2ef710e7765a35c39b648d6d239867f6c47473" => :mojave
  end

  depends_on "cmake" => :build
  depends_on "openssl@1.1"

  uses_from_macos "curl"

  # Fix system curl detection
  # See https://github.com/whoshuu/cpr/pull/428
  #
  # Remove in the next release
  patch do
    url "https://github.com/whoshuu/cpr/commit/451fd1a896c963367ebb3d77cfe4550b2d5636f3.patch?full_index=1"
    sha256 "74349209c5d28d9261871080341c735517b3e64e91ac6cc6884abb2767f14b33"
  end

  def install
    args = std_cmake_args
    args << "-DUSE_SYSTEM_CURL=ON"
    args << "-DBUILD_CPR_TESTS=OFF"

    system "cmake", ".", *args, "-DBUILD_SHARED_LIBS=ON"
    system "make", "install"

    system "make", "clean"
    system "cmake", ".", *args, "-DBUILD_SHARED_LIBS=OFF"
    system "make"
    lib.install "lib/libcpr.a"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <cpr/cpr.h>

      int main(int argc, char** argv) {
          auto r = cpr::Get(cpr::Url{"https://example.org"});
          std::cout << r.status_code << std::endl;

          return 0;
      }
    EOS

    system ENV.cxx, "test.cpp", "-std=c++11", "-I#{include}", "-L#{lib}",
                    "-lcpr", "-o", testpath/"test"
    assert_match "200", shell_output("./test")
  end
end
