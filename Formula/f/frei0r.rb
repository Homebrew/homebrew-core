class Frei0r < Formula
  desc "Minimalistic plugin API for video effects"
  homepage "https://frei0r.dyne.org/"
  url "https://github.com/dyne/frei0r/archive/refs/tags/v3.2.3.tar.gz"
  sha256 "898f80e5fdae6108a2d9b2317649af576a4b5e636c73429ee11b64397a596e12"
  license "GPL-2.0-or-later"
  compatibility_version 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c9d0f4182f949593a52d48df80cd40ee4cd95be38fc4649a73b93a683978a050"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7f903a915e450c305cb4f384f8610c10923f4c869222e2605f88357840cbfdc3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fccb06147d52a56a646316373591fddf9ff912e32e0e588bf9fd80639207004d"
    sha256 cellar: :any_skip_relocation, sonoma:        "a81b5df6769ced94ed826bbbf4dae50e2e165cd14277fe34cf2b6d8f77fa9ab3"
    sha256 cellar: :any,                 arm64_linux:   "77674ceba062a1980f5251f6d62e91bb967bf98277dddd3d89c9740fcc43b26d"
    sha256 cellar: :any,                 x86_64_linux:  "2c3e214f8fcbfa9543ec1ff521c0a3c8db6c15766347a38dcc9faebc3302dcdc"
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
