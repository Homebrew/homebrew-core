class Libre < Formula
  desc "Toolkit library for asynchronous network I/O with protocol stacks"
  homepage "https://github.com/baresip/re"
  url "https://github.com/baresip/re/archive/refs/tags/v3.11.0.tar.gz"
  sha256 "a29dbdbbacd27461b9c8e94b0e52773f3b1396a64e31e258635f18cf5f27e44e"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f897106dd66c5ee487031d2b0e3895e72ae0bd494cb81fce5f8c508130af5fcb"
    sha256 cellar: :any,                 arm64_ventura:  "9018d99e206b8b5fe598c9306553ba44c6ecbcf7e2d6a16182388545e3f8398e"
    sha256 cellar: :any,                 arm64_monterey: "47b5b4ebfdb5c0da6fe3e52bcdf6efdb98b11c4c8564f34b5a50091ba8d37848"
    sha256 cellar: :any,                 sonoma:         "2927b4e1a9420b1c9bfd6f93d058352bb975c96a0e981332653244a475e3e5b7"
    sha256 cellar: :any,                 ventura:        "45265fe628625697e3c84f9bc7d8acd49851dd82190f4b0e4148a48a36931840"
    sha256 cellar: :any,                 monterey:       "6b5a3349f9979a5a73174bbb8ed013658b1319b24b5ab3d0cb1707f1e7cb7040"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c3762147189472f6c2104091e36a6985a55a7c9fee56c6225bb2a99458d20c08"
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
    (testpath/"test.c").write <<~EOS
      #include <stdint.h>
      #include <re/re.h>
      int main() {
        return libre_init();
      }
    EOS
    system ENV.cc, "-I#{include}", "-I#{include}/re", "test.c", "-L#{lib}", "-lre"
  end
end
