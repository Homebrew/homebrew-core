class Libre < Formula
  desc "Toolkit library for asynchronous network I/O with protocol stacks"
  homepage "https://github.com/baresip/re"
  url "https://github.com/baresip/re/archive/refs/tags/v4.7.0.tar.gz"
  sha256 "b9fd286e30df103b3e06be2f821503d6f21551002737c4b8f47cf8db30dd5e19"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c4849b9398137a10a5ba3ffab29c7a1a6223b84c62defb5443cf2a308082abe9"
    sha256 cellar: :any,                 arm64_sequoia: "44e0e7858b06c671ce7cf7efbb1c73cea6aaf0dff14a370ba444bf74d6505de7"
    sha256 cellar: :any,                 arm64_sonoma:  "e21769e6c8a9d9b692ddca7e38dcfaf0400817fa5cb37ee12a558d818be53c6f"
    sha256 cellar: :any,                 sonoma:        "4220322ee8a3a529a3087ea818db393a3ea0e164a02b6848f998a10fea1a0271"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "07efd22a55d3ab0502375dec2d1e4c634d71b45a09e154a0015e1419111ddac7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dbb565a5be6533757165374d5172aa8cdc168a7a6bfbd31464dafe5117700432"
  end

  depends_on "cmake" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
