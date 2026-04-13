class Frei0r < Formula
  desc "Minimalistic plugin API for video effects"
  homepage "https://frei0r.dyne.org/"
  url "https://github.com/dyne/frei0r/archive/refs/tags/v3.1.1.tar.gz"
  sha256 "0eaab07b22de1bc9aede84e4a62604e9da05642709a4e935871f4a4973bf703b"
  license "GPL-2.0-or-later"
  compatibility_version 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aa84227039f2e2c5a9cd23150a2268f68b518dce731d8c9c43bfa466198d65c8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b712df391f23ce1855fd8272b1b576a14e73b2156c7c19e4f64259a398c3807a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1c7b39f3c0de8b6a20e3f7d1296f14e983a3918e76bd1c054b255f74f3596ee3"
    sha256 cellar: :any_skip_relocation, sonoma:        "4929b92921e9779a3505b9cdb488025154e7ef46f0e40c61786f537d3c749e3c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "94d96833a706b94ca3def269c6c987a94fd1a2becd300fc84ec8345acef5ecb9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c8901cf967d1d3a3452373c0fea9169ddbf8a1951db3dc8d4d95562878d10d6"
  end

  depends_on "cmake" => :build

  def install
    args = %w[
      -DWITHOUT_OPENCV=ON
      -DWITHOUT_GAVL=ON
      -DWITHOUT_CAIRO=ON
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
