class Frei0r < Formula
  desc "Minimalistic plugin API for video effects"
  homepage "https://frei0r.dyne.org/"
  url "https://github.com/dyne/frei0r/archive/refs/tags/v2.5.1.tar.gz"
  sha256 "318ec4a3042c94a00a58fccdc1eb0d911f36a22beb3504d27aefcca4598f40b0"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e2047ddbfd007416c55d75edbfc1c71a8ce83c0443ad5901e443b79df2e7606f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7185662489177e81190e769c8d407b99d3c438443f5942b073f27b02c72f46c3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "395b5e3b1837a3f171bb4b7be4ad2dfca2a210754396a75bdc0fce43fa537421"
    sha256 cellar: :any_skip_relocation, sonoma:        "d668f703092d5c525f8a968e4c969755356de1abc6979ce18c87081448147194"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f7334ae0b75380b6d14b8d2e054e5b8ade2792e517c155004664375c2d8711a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f188e001f3d5ef0af3d5e75fffc72b984dcd73ca3cdd6792782c0fcd13e02ef"
  end

  depends_on "cmake" => :build

  def install
    # Disable opportunistic linking against Cairo
    inreplace "CMakeLists.txt", "find_package (Cairo)", ""

    args = %w[
      -DWITHOUT_OPENCV=ON
      -DWITHOUT_GAVL=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <frei0r.h>

      int main()
      {
        int mver = FREI0R_MAJOR_VERSION;
        if (mver != 0) {
          return 0;
        } else {
          return 1;
        }
      }
    C
    system ENV.cc, "-L#{lib}", "test.c", "-o", "test"
    system "./test"
  end
end
