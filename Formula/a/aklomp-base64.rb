class AklompBase64 < Formula
  desc "Fast Base64 stream encoder/decoder in C99, with SIMD acceleration"
  homepage "https://github.com/aklomp/base64"
  url "https://github.com/aklomp/base64/archive/refs/tags/v0.5.2.tar.gz"
  sha256 "723a0f9f4cf44cf79e97bcc315ec8f85e52eb104c8882942c3f2fba95acc080d"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3daaafdc28fb46f6aa2f966dbc3215aac870cde7c32490c314ac22f284b0f065"
    sha256 cellar: :any,                 arm64_sequoia: "224ec7e34699c7e20fdeaf82fbc3c2f9095976aeeb9a3b3c2a1da51e6412cc71"
    sha256 cellar: :any,                 arm64_sonoma:  "9280f92f3823ce2a46df639b8b2f3d8346f172f92cede706b1ff0bb3ecb95d7e"
    sha256 cellar: :any,                 sonoma:        "315b527699ff71266db22bdd47d39a9de2f6043d17694f05554f316ac8f97fc3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "520b2d0968addeb42a64a90107bbd20d06a271dc305f0341638c4c3f61eae998"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "72f952c1e3ad8fd261cf9e76a8583f57855615a775044bce93b29c4f23cad175"
  end

  depends_on "cmake" => :build

  conflicts_with "base64", because: "both install `base64` binaries"

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_equal "aGVsbG8=", pipe_output(bin/"base64", "hello", 0).strip
  end
end
