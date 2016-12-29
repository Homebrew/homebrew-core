class Libchaos < Formula
  desc "Advanced library for randomization, hashing and statistical analysis."
  homepage "https://github.com/maciejczyzewski/libchaos"
  url "https://github.com/maciejczyzewski/libchaos/releases/download/v1.0/libchaos-1.0.tar.gz"
  sha256 "29940ff014359c965d62f15bc34e5c182a6d8a505dc496c636207675843abd15"

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", "-DLIBCHAOS_ENABLE_TESTING=OFF", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"t_libchaos.cc").write <<-EOS
    #include <iostream>
    #include <string>
    #include <assert.h>

    #include <chaos.h>

    int main(void) {
      assert(strcmp(CHAOS_META_NAME(CHAOS_MACHINE_XORRING64),
        "xorring64") == 0);
      std::string hash = chaos::password<CHAOS_MACHINE_XORRING64, 175, 25, 40>(
        "some secret password", "my private salt");
      std::cout << hash << std::endl;
      return 0;
    }
    EOS

    system ENV.cxx, "-std=c++11", "-lchaos", "-o", "t_libchaos", "t_libchaos.cc"
    system "./t_libchaos"
  end
end
