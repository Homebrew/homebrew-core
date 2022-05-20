class Libchaos < Formula
  desc "Advanced library for randomization, hashing and statistical analysis"
  homepage "https://github.com/maciejczyzewski/libchaos"
  url "https://github.com/maciejczyzewski/libchaos/releases/download/v1.0/libchaos-1.0.tar.gz"
  sha256 "29940ff014359c965d62f15bc34e5c182a6d8a505dc496c636207675843abd15"
  license "BSD-2-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5cbe23d7c195b8cb1e7336596112bb1f84b3579cca069b5bc9b61e41c640e32f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e1b5eff28e28622055d915653c66c2448cba0cb207a8b8f243525c2deb1dd246"
    sha256 cellar: :any_skip_relocation, monterey:       "018d34f680d426fab143744ab7413cfdb8db204ac5bc0a77de9767a2802bbf5c"
    sha256 cellar: :any_skip_relocation, big_sur:        "2b51e7e88ad2f47cdb860d3edbf65a9db6a1a0feeefbb46dae978f3b4311f20f"
    sha256 cellar: :any_skip_relocation, catalina:       "8cd295f6ccf1c6a09ab87bef06331424da21b0b44da8f4440a11f4fccaf1370a"
    sha256 cellar: :any_skip_relocation, mojave:         "3add0509ec493248105ad81354c4ffccef85f37c0cc445db24f115b0b8fb3576"
    sha256 cellar: :any_skip_relocation, high_sierra:    "8d1f167a096fae20de66286d9f33a7b93e03fcfccaecd5b15611e3fcd7c4b09c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a1add1c600d4abf7d5cb5e4268810c4f3f8f29a6a4a5ea267c95202230881b8f"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DLIBCHAOS_ENABLE_TESTING=OFF",
           "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    system "cmake", "-S", ".", "-B", "build", "-DLIBCHAOS_ENABLE_TESTING=OFF",
           "-DBUILD_SHARED_LIBS=OFF", *std_cmake_args
    system "cmake", "--build", "build"
    lib.install buildpath/"build/libchaos.a"
  end

  test do
    (testpath/"test.cc").write <<~EOS
      #include <chaos.h>
      #include <iostream>
      #include <string>

      int main(void) {
        std::cout << CHAOS_META_NAME(CHAOS_MACHINE_XORRING64) << std::endl;
        std::string hash = chaos::password<CHAOS_MACHINE_XORRING64, 175, 25, 40>(
            "some secret password", "my private salt");
        std::cout << hash << std::endl;
        if (hash.size() != 40)
          return 1;
        return 0;
      }
    EOS

    system ENV.cxx, "test.cc", "-std=c++11", "-L#{lib}", "-lchaos", "-o", "test"
    system "./test"
  end
end
