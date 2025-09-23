class Libilbc < Formula
  desc "Packaged version of iLBC codec from the WebRTC project"
  homepage "https://github.com/TimothyGu/libilbc"
  url "https://github.com/TimothyGu/libilbc/releases/download/v3.0.4/libilbc-3.0.4.tar.gz"
  sha256 "6820081a5fc58f86c119890f62cac53f957adb40d580761947a0871cea5e728f"
  license "BSD-3-Clause"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "b55c9c6554101b871be2016309c318fdc796dfa89addd0df918179fd048e80a0"
    sha256 cellar: :any,                 arm64_sequoia:  "3e5872934eb657baeb5b1a02dd4f1d41fccb539aa8470718644305bb5ab3cd28"
    sha256 cellar: :any,                 arm64_sonoma:   "4909ecace33503559f651e6bd82cc0cc4e3d1248572f42796ceaa07c85ccb47b"
    sha256 cellar: :any,                 arm64_ventura:  "36774c3a7db279a6932326411a82cd1ffe92e66ee0fead069d985e0e17231309"
    sha256 cellar: :any,                 arm64_monterey: "62792538776c6c61167769ce53ed0998c849b89ca9cc5ade0261be739bd8bf60"
    sha256 cellar: :any,                 arm64_big_sur:  "7b07dbf92042eb0f0692aec0381561eaa0a9c649347fd321ebf74cd22994813d"
    sha256 cellar: :any,                 sonoma:         "d5d2dc90d135c52f15befb996483d7c2705c77205d7aa57b2286ff96678f3f7a"
    sha256 cellar: :any,                 ventura:        "d6cb8d5175be0fbd28cfd5a123685b17fdc5da1aca7720b15bc6d0e9bc28ae47"
    sha256 cellar: :any,                 monterey:       "a60c72751ea180c155b7994fd71ef068118b74665a3199e61a0b4adda27c64ad"
    sha256 cellar: :any,                 big_sur:        "affe65f4320a2940b69ec54687be6c5387e51d79f3fd418a5dc42924c99eeee0"
    sha256 cellar: :any,                 catalina:       "b75ace51e88894a45e406c7fbe4b4cafc06932b0e5ce90480fdee203aa9ede83"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "5848c1f801acd864b6e44672dff531f3cd357e93a64ee64ff8bc3bda3ef6e2a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "11914a90369fc2c32d1373c3c8d5a98275c44de6e70301c23067b67310d6bba0"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <ilbc.h>
      #include <stdio.h>

      int main() {
        char version[255];

        WebRtcIlbcfix_version(version);
        printf("%s", version);
        return 0;
      }
    C

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lilbc", "-o", "test"
    system "./test"
  end
end
