class Libilbc < Formula
  desc "Packaged version of iLBC codec from the WebRTC project"
  homepage "https://github.com/TimothyGu/libilbc"
  url "https://github.com/TimothyGu/libilbc/releases/download/v3.0.2/libilbc-3.0.2.tar.gz"
  sha256 "e82cbc41c8c84c0828af869a9c6bbb62e06dece0d17d069c8b9db95082f0a4ce"
  license "BSD-3-Clause"

  bottle do
    cellar :any
    sha256 "2fead9d7113ffad5aaa75fd4cdf875071865947c69aed68fbe542b1603d9c364" => :big_sur
    sha256 "3a8caa126466fcf7cde71363a4423e709b249f0a7318a22e5bd545d3d5382ea3" => :catalina
    sha256 "cbb71770ab1bc1647e719d9b084d710c8c5c4e37a0b1a70e53650b3fb24cda62" => :mojave
    sha256 "63df659558f7961f6e04c347dad5ef6508578e86e0c13b15d39fb267dcc440db" => :high_sierra
    sha256 "421757bd970d1ba1d0c1fe2eff208cc0b44f8a75bbf9a09344ba504ad377750f" => :sierra
    sha256 "fff34390e949e037bb4b16937b62ab4993f55d2fb805656116ceab6a7c9b6e83" => :el_capitan
    sha256 "7f16b3e0f254f35be8b6275339dc813a6443f65d1c27e1748e08835a49733f6f" => :yosemite
    sha256 "7aa8495e4050ea38152ec218452d6fac97387ad385a6d63806238e838664471b" => :mavericks
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DBUILD_SHARED_LIBS=ON"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <ilbc.h>
      #include <stdio.h>

      int main() {
        char version[255];

        WebRtcIlbcfix_version(version);
        printf("%s", version);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lilbc", "-o", "test"
    system "./test"
  end
end
