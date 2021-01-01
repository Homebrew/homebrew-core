class Libilbc < Formula
  desc "Packaged version of iLBC codec from the WebRTC project"
  homepage "https://github.com/TimothyGu/libilbc"
  url "https://github.com/TimothyGu/libilbc/releases/download/v3.0.4/libilbc-3.0.4.tar.gz"
  sha256 "6820081a5fc58f86c119890f62cac53f957adb40d580761947a0871cea5e728f"
  license "BSD-3-Clause"

  bottle do
    cellar :any
    sha256 "7cf3a9708a5e405ae07b1e30862fe2636813e3d4675f5410907def2f5eeb5de1" => :big_sur
    sha256 "1549132b9cb58c91b1f437ec1212b9ad59c7788f006b34e7ea29a030f25e3788" => :arm64_big_sur
    sha256 "922b31da0782f99be36442b29a12b894f582153db289e19d33c39377d1a53a16" => :catalina
    sha256 "709aca6a8540a022a9a8f52973f9796eee258c395321d3e311a38b67f960884c" => :mojave
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
