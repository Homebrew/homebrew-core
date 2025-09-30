class CAres < Formula
  desc "Asynchronous DNS library"
  homepage "https://c-ares.org/"
  url "https://github.com/c-ares/c-ares/releases/download/v1.34.5/c-ares-1.34.5.tar.gz"
  sha256 "7d935790e9af081c25c495fd13c2cfcda4792983418e96358ef6e7320ee06346"
  license "MIT"
  head "https://github.com/c-ares/c-ares.git", branch: "main"

  livecheck do
    url :homepage
    regex(/href=.*?c-ares[._-](\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "f1ea4e3a48f43370fac2a1d2c285e87fadc48ab3dbda63b39d8eb04b025925d7"
    sha256 cellar: :any,                 arm64_sequoia: "76858a7f6dd6df68f7e9d13aca30a299d5947b5b6d6ce979ee660dd4ecca2bb6"
    sha256 cellar: :any,                 arm64_sonoma:  "5bc958432063e6dc18633d06f1ef2a6939c60bfc60d3d9162183c71556e21198"
    sha256 cellar: :any,                 arm64_ventura: "60dcb45f4148187db1aa35a2ea1fd195126448b0c013fb04ec2412788c09156a"
    sha256 cellar: :any,                 sonoma:        "c152939c8cbf3784c07d1c335fa4d8a279926613ef8a63fd8b86ce0c9fc2c1ce"
    sha256 cellar: :any,                 ventura:       "ec24a40eb0839a531fefd518d459d9096594c8d5f99073cb14dd90818aac1443"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7edb30f8604f12af709a3edd142cd1e4e0fa6d6ac9592ccd81687dac5344400a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "222c77a232de91b511238cf81f3290b5e5f7d788f7011a447ad92ae38089fa72"
  end

  depends_on "cmake" => :build

  def install
    args = %W[
      -DCARES_STATIC=ON
      -DCARES_SHARED=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <ares.h>

      int main()
      {
        ares_library_init(ARES_LIB_INIT_ALL);
        ares_library_cleanup();
        return 0;
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-lcares", "-o", "test"
    system "./test"

    system bin/"ahost", "127.0.0.1"
  end
end
