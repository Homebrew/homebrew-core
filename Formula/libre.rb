class Libre < Formula
  desc "Toolkit library for asynchronous network I/O with protocol stacks"
  homepage "https://github.com/baresip/re"
  url "https://github.com/baresip/re/archive/refs/tags/v2.11.0.tar.gz"
  sha256 "2e3c0c8d1eb4879bfa8ec3329d3bab1d9b24a724d8e1a3cce57c4db58664f03d"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c7d463b9a3cd136b2bd71565b1976355145ff79aefefee8e0e2826936d1a6b5e"
    sha256 cellar: :any,                 arm64_monterey: "c1639d21606975a56d5f0093900f3cffc604f3057f0127e6cc3b3b9b8447cb02"
    sha256 cellar: :any,                 arm64_big_sur:  "44df50d7545a2d48ef61ec184d776e1c604ef12873723e9128ec99e6088df8f8"
    sha256 cellar: :any,                 ventura:        "d8738736cdd1c1aaf26df6357fb8d4da0821e3e85e055f2b9abfdce8cee57f8f"
    sha256 cellar: :any,                 monterey:       "915f96fa9d8346e9e4ff7c8cb271287c122d84eb6347e93059f2d5da154996ec"
    sha256 cellar: :any,                 big_sur:        "daaa97bbaf3c5acd4464a8a1d8da7e25668434907faf1222b185a7749886e1f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c0553f193f135f8ca44a3d04bbac3510049b98bff41512f6fc8616ed17150665"
  end

  depends_on "cmake" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    system "cmake", "-B", "build", "-DCMAKE_BUILD_TYPE=Release", *std_cmake_args
    system "cmake", "--build", "build", "-j"
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
    system ENV.cc, "test.c", "-L#{lib}", "-lre"
  end
end
