class Libfyaml < Formula
  desc "Fully feature complete YAML parser and emitter"
  homepage "https://github.com/pantoniou/libfyaml"
  url "https://github.com/pantoniou/libfyaml/releases/download/v0.9.6/libfyaml-0.9.6.tar.gz"
  sha256 "a59cc3331e2eb903ec36933ad52a45888041cac31e44f553a00511131242c483"
  license "MIT"
  compatibility_version 1

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "136a14b21e893b22e406404feccdcb478056fe48dcd9ad9449202ac1620e5294"
    sha256 cellar: :any, arm64_sequoia: "e9dfc578d1d8a9b612a439dcae6bf01b7b8994556be9aaad47d115c777b87022"
    sha256 cellar: :any, arm64_sonoma:  "b873d5ae917e943b1862f12d6f974e766b38e9259a922ce7fb7da2c5ad78ac87"
    sha256 cellar: :any, sonoma:        "6ef1d63d2fba0cc36edfbd8630e590d8d4960ce5d0c3a80e0be0d367e6ea2973"
    sha256 cellar: :any, arm64_linux:   "04cc26685b812dd7cb9ef33f4b5184866efbec2d83a9eb1df073d893bb683dd6"
    sha256 cellar: :any, x86_64_linux:  "73fee9b57749aebf0ea4918e7a46b9abc1583e339771e1adcda6bff2a404dee6"
  end

  depends_on "cmake" => :build

  # TODO: Remove patch in next release
  patch do
    url "https://github.com/pantoniou/libfyaml/commit/1026d76850909dc9b1c5f95b8cd94e865a313fd5.patch?full_index=1"
    sha256 "05e07134edfae8c4d6b81fd25b013c471a3790736f61d6888035409d570ce636"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_RPATH=#{rpath}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #ifdef HAVE_CONFIG_H
      #include "config.h"
      #endif

      #include <iostream>
      #include <libfyaml.h>

      int main(int argc, char *argv[])
      {
        std::cout << fy_library_version() << std::endl;
        return EXIT_SUCCESS;
      }
    CPP
    system ENV.cxx, "test.cpp", "-I#{include}", "-L#{lib}", "-lfyaml", "-o", "test"
    assert_equal 0, $CHILD_STATUS.exitstatus
    assert_equal version.to_s, shell_output("#{testpath}/test").strip
    assert_equal version.to_s, shell_output("#{bin}/fy-tool --version").strip
  end
end
