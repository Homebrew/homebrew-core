class Libre < Formula
  desc "Toolkit library for asynchronous network I/O with protocol stacks"
  homepage "https://github.com/baresip/re"
  url "https://github.com/baresip/re/archive/refs/tags/v3.16.0.tar.gz"
  sha256 "11b3215064b6ef5a11b0f4645d6d4834f8ba899d5b65c66477f9c4afbd32e1ed"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "02558efbd753c2828ccc4f91524dca92a1c4fc2c5b75c96b58473f7357b05a20"
    sha256 cellar: :any,                 arm64_sonoma:  "c301ade603751c88020715a54450b36c4f53e20554e645bc12da67172d1bba8d"
    sha256 cellar: :any,                 arm64_ventura: "26bc4638e19d6e26b0e780e2041b4faaaf30b2970e51e7ce1bebd1456855e89e"
    sha256 cellar: :any,                 sonoma:        "13693d80705176c802c502aeac1847868699cd8fd80986958bfa6a2ef013c044"
    sha256 cellar: :any,                 ventura:       "813f09b9bcdad0d04438d6ced16cf743b754097dfc1a42a8048fc8cf9606d715"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c3d699e934426185b44b2603ac3e21a9981363b914c3a1401eb95943779ef20e"
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
