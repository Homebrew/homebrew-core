class Libre < Formula
  desc "Toolkit library for asynchronous network I/O with protocol stacks"
  homepage "https://github.com/baresip/re"
  url "https://github.com/baresip/re/archive/refs/tags/v4.4.0.tar.gz"
  sha256 "fd7d8bd9ce31aee6ce95e0162931330493b6ca816fa7eb00a6801ca1af01745c"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a29017c6c68d56ea7f28f79010e3f4279fa9f1ae49fa430c830c3386de0e66af"
    sha256 cellar: :any,                 arm64_sequoia: "68d21d2fcfa677398b4dea15812ca014e05ca3c06fb6a51e8dc19af23c638882"
    sha256 cellar: :any,                 arm64_sonoma:  "9a66e4fd0c389f99f9882517f000c5335d7f875a450b362681a72c07a848aad3"
    sha256 cellar: :any,                 sonoma:        "5ab3bc7e6922cce5a1a186b0c670f35de12efe51d1c5e7960f9fd62e4590b780"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5cb20117f8b7785e02582520ec6fe5efcfa48582c3526069bb98dd928736e870"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f2eac19de6abafce9d5d9a86d7f674024b394fc5883485d4c9fb357b9473923b"
  end

  depends_on "cmake" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    system "cmake", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdint.h>
      #include <re/re.h>
      int main() {
        return libre_init();
      }
    C
    system ENV.cc, "-I#{include}", "-I#{include}/re", "test.c", "-L#{lib}", "-lre"
  end
end
