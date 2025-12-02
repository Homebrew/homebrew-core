class Libre < Formula
  desc "Toolkit library for asynchronous network I/O with protocol stacks"
  homepage "https://github.com/baresip/re"
  url "https://github.com/baresip/re/archive/refs/tags/v4.3.0.tar.gz"
  sha256 "555d3b6dfaeb4809b5fdc5081686ebde8486ea6e479f2cb99256a5bcfdb18b24"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "176e2cc61c8dde4419fa57b1c66f6d09bbc3a395fb8970c078b567f5486d7b62"
    sha256 cellar: :any,                 arm64_sequoia: "ac55bf8dbeb0f737a11a7d1279132be369cc98d665d24f9500ef4e3fc473e567"
    sha256 cellar: :any,                 arm64_sonoma:  "9f8cd1344dee524415bb29bc8fc55d7b1e3dd37d4c1215f8474296a8ba50c35b"
    sha256 cellar: :any,                 sonoma:        "91945fd01111af1bf190b62297fbfe112ef7c5534f4a2ed45abac7ed2051530c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "29ea87135ad361a9b5c1122cee744a199f5e487c8c7ebb5e247cf6be40dfac5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "32970ce9db3807c8389dc82f4be98e0377d02bd4b44cb31d60ddbd03f257a13d"
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
