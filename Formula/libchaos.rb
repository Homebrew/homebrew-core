class Libchaos < Formula
  desc "Advanced library for randomization, hashing and statistical analysis"
  homepage "https://github.com/maciejczyzewski/libchaos"
  url "https://github.com/maciejczyzewski/libchaos/releases/download/v1.0/libchaos-1.0.tar.gz"
  sha256 "29940ff014359c965d62f15bc34e5c182a6d8a505dc496c636207675843abd15"

  bottle do
    cellar :any_skip_relocation
    sha256 "455684b3231e25573fbe448f089a5d77639f5cc187b8088295239a9cd4277b80" => :mojave
    sha256 "fe7a54d3b9f42525436524b6449a78fc412589787ab539738349aad199371ed9" => :high_sierra
    sha256 "476414dff3721c654468f3022b4a53506e3bbfad31314714025b3226fdd254d2" => :sierra
    sha256 "40534621ddbbf1e05aada56c23034a99373e00c9c00140c0a0b5c687e1379e14" => :el_capitan
    sha256 "8aeaf844fa6f07faecb2efe9a91d4ca1dfcedd31b8f9c4bfc4e2c2a388d80b27" => :yosemite
  end

  depends_on "cmake" => :build
  needs :cxx11

  def install
    mkdir "build" do
      system "cmake", "..", "-DLIBCHAOS_ENABLE_TESTING=OFF", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"t_libchaos.cc").write <<~EOS
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

    system ENV.cxx, "-std=c++11", "-lchaos", "-o", "t_libchaos", "t_libchaos.cc"
    system "./t_libchaos"
  end
end
