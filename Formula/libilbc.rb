class Libilbc < Formula
  desc "Packaged version of iLBC codec from the WebRTC project"
  homepage "https://github.com/TimothyGu/libilbc"
  url "https://github.com/TimothyGu/libilbc/releases/download/v3.0.4/libilbc-3.0.4.tar.gz"
  sha256 "6820081a5fc58f86c119890f62cac53f957adb40d580761947a0871cea5e728f"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "62792538776c6c61167769ce53ed0998c849b89ca9cc5ade0261be739bd8bf60"
    sha256 cellar: :any,                 arm64_big_sur:  "7b07dbf92042eb0f0692aec0381561eaa0a9c649347fd321ebf74cd22994813d"
    sha256 cellar: :any,                 monterey:       "a60c72751ea180c155b7994fd71ef068118b74665a3199e61a0b4adda27c64ad"
    sha256 cellar: :any,                 big_sur:        "affe65f4320a2940b69ec54687be6c5387e51d79f3fd418a5dc42924c99eeee0"
    sha256 cellar: :any,                 catalina:       "b75ace51e88894a45e406c7fbe4b4cafc06932b0e5ce90480fdee203aa9ede83"
    sha256 cellar: :any,                 mojave:         "496492e1aaecb1b41ba83eb033b75777ca08333edbb9e67bef23c933b5847cd5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "11914a90369fc2c32d1373c3c8d5a98275c44de6e70301c23067b67310d6bba0"
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
