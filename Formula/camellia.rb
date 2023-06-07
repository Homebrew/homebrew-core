class Camellia < Formula
  desc "Image Processing & Computer Vision library written in C"
  homepage "https://camellia.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/camellia/Unix_Linux%20Distribution/v2.7.0/CamelliaLib-2.7.0.tar.gz"
  sha256 "a3192c350f7124d25f31c43aa17e23d9fa6c886f80459cba15b6257646b2f3d2"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(%r{url=.*?/CamelliaLib[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a5c4c63a17ade79c28f3e4486befcdba33df0693d28df9c5bad81dcf2cdf8696"
    sha256 cellar: :any,                 arm64_monterey: "f406463c27cb4ffa13ace7d45ab4565f39b2298246ddb7b671d75f5bac5b0382"
    sha256 cellar: :any,                 arm64_big_sur:  "ecd83455b65819e9275ead160b6fca0a1a13e8b85d00c63e394ecdb5818b3a78"
    sha256 cellar: :any,                 ventura:        "60de7bb06d85c339db0c5e43ee8965bbd3b8ab6209c292018d02f635d208d9c5"
    sha256 cellar: :any,                 monterey:       "2a5a68dce9404d513ed22a4a26a2968af84cc2e4df607edf3013a2b24912205d"
    sha256 cellar: :any,                 big_sur:        "84ce9367fd905515a5532cd64be374177b369f8c1797808a2ec95b5c89799965"
    sha256 cellar: :any,                 catalina:       "c7d2e77a15331cebfeff928b67bd32ee5b0a9325ac5cbea022b2c6ddbe585ff6"
    sha256 cellar: :any,                 mojave:         "347284dc085d1cd6acad286e8797ba3e001190e7cb04934b1f96d1e67481f302"
    sha256 cellar: :any,                 high_sierra:    "fc8cb8a0f24226fd1f93b32192f290107d44283196e1edb48458b184597aa729"
    sha256 cellar: :any,                 sierra:         "b4783ca8cf782a63d09daa1ff363c2fb4c4ea6dd4e75b8beb29167f536227730"
    sha256 cellar: :any,                 el_capitan:     "a80b2f52fd6811c5c4017bceac418d241c30342c93c1e9ae8911ed5274630e9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3eaafd00c8c6f8addff45fa1be46912ec2b411552450c48dbe09795c1ec7e370"
  end

  def install
    # Fix missing include - https://sourceforge.net/p/camellia/bugs/1/
    # cam_demo_cpp.cpp:212:52: error: ‘sprintf’ was not declared in this scope
    if OS.linux?
      inreplace "cam_demo_cpp.cpp",
                "#include <stdlib.h>\r\n",
                "#include <stdlib.h>\r\n#include <stdio.h>\r\n"
    end

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include "camellia.h"
      int main() {
        CamImage image; // CamImage is an internal structure of Camellia
        return 0;
      }
    EOS

    system ENV.cxx, "test.cpp", "-I#{include}", "-L#{lib}", "-lCamellia", "-o", "test"
    system "./test"
  end
end
