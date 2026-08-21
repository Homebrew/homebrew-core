class Frei0r < Formula
  desc "Minimalistic plugin API for video effects"
  homepage "https://frei0r.dyne.org/"
  url "https://github.com/dyne/frei0r/archive/refs/tags/v3.4.3.tar.gz"
  sha256 "656ad48303cf2d7c81061684622abc9fe4c309f5dc1f32211958bfd19cb28ff7"
  license "GPL-2.0-or-later"
  compatibility_version 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3942ed0ae1c497195e288d4ebb22f3dbc69017097e6e0f9d96306a6ab4a6abf3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a46481adf5f0579edb973ff18ab4b9f7119ba50ee88cb2e7875e3a2015e52f01"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3a2932f2ba83954a508b735a844972236fc67c3e82844420c73a3a76de6fa9ba"
    sha256 cellar: :any_skip_relocation, sonoma:        "4af9a166aaa7fe311b3eb94032dafee054eeb6082c32f578453cbcd7185414bd"
    sha256 cellar: :any,                 arm64_linux:   "a03523f3edc0983b9d1dca846a369f10cbffa4936fbf59e3361297a6adb762b3"
    sha256 cellar: :any,                 x86_64_linux:  "5c8fb5e4df8267c7defc46a16423cf61252add1c5086e7be1e2a1c8d4c7fce51"
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
