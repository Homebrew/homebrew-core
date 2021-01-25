class Libilbc < Formula
  desc "Packaged version of iLBC codec from the WebRTC project"
  homepage "https://github.com/TimothyGu/libilbc"
  url "https://github.com/TimothyGu/libilbc/releases/download/v3.0.4/libilbc-3.0.4.tar.gz"
  sha256 "6820081a5fc58f86c119890f62cac53f957adb40d580761947a0871cea5e728f"
  license "BSD-3-Clause"

  bottle do
    cellar :any
    sha256 "affe65f4320a2940b69ec54687be6c5387e51d79f3fd418a5dc42924c99eeee0" => :big_sur
    sha256 "7b07dbf92042eb0f0692aec0381561eaa0a9c649347fd321ebf74cd22994813d" => :arm64_big_sur
    sha256 "b75ace51e88894a45e406c7fbe4b4cafc06932b0e5ce90480fdee203aa9ede83" => :catalina
    sha256 "496492e1aaecb1b41ba83eb033b75777ca08333edbb9e67bef23c933b5847cd5" => :mojave
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
