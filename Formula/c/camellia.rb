class Camellia < Formula
  desc "Image Processing & Computer Vision library written in C"
  homepage "https://camellia.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/camellia/Unix_Linux%20Distribution/v2.7.0/CamelliaLib-2.7.0.tar.gz"
  sha256 "a3192c350f7124d25f31c43aa17e23d9fa6c886f80459cba15b6257646b2f3d2"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(%r{url=.*?/CamelliaLib[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "c02cf24237f1d621d5b395cb126efba1128b422026385868a8bf42ba2444d0fd"
    sha256 cellar: :any,                 arm64_sequoia:  "0679b21bf4e69b52af575fc7c30370b2fe0e70d2639b6fa550f3b4b3a3dfa392"
    sha256 cellar: :any,                 arm64_sonoma:   "c635eb57ac492aa11db11d6f08cfeee90951308007401fa2a20152db16cd57e1"
    sha256 cellar: :any,                 arm64_ventura:  "a5c4c63a17ade79c28f3e4486befcdba33df0693d28df9c5bad81dcf2cdf8696"
    sha256 cellar: :any,                 arm64_monterey: "f406463c27cb4ffa13ace7d45ab4565f39b2298246ddb7b671d75f5bac5b0382"
    sha256 cellar: :any,                 arm64_big_sur:  "ecd83455b65819e9275ead160b6fca0a1a13e8b85d00c63e394ecdb5818b3a78"
    sha256 cellar: :any,                 sonoma:         "4ea29c13f4d2158b8c34fe8dd86b91ead0286cc3127faaa5314544a5e1877125"
    sha256 cellar: :any,                 ventura:        "60de7bb06d85c339db0c5e43ee8965bbd3b8ab6209c292018d02f635d208d9c5"
    sha256 cellar: :any,                 monterey:       "2a5a68dce9404d513ed22a4a26a2968af84cc2e4df607edf3013a2b24912205d"
    sha256 cellar: :any,                 big_sur:        "84ce9367fd905515a5532cd64be374177b369f8c1797808a2ec95b5c89799965"
    sha256 cellar: :any,                 catalina:       "c7d2e77a15331cebfeff928b67bd32ee5b0a9325ac5cbea022b2c6ddbe585ff6"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "54fa3c308a4e301534567e1e0cf9a35c303c271ee8f213b9a4321b944d373c8e"
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

    args = []
    # Help old config scripts identify arm64 linux
    args << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include "camellia.h"
      int main() {
        CamImage image; // CamImage is an internal structure of Camellia
        return 0;
      }
    CPP

    system ENV.cxx, "test.cpp", "-I#{include}", "-L#{lib}", "-lCamellia", "-o", "test"
    system "./test"
  end
end
