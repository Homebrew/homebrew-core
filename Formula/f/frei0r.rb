class Frei0r < Formula
  desc "Minimalistic plugin API for video effects"
  homepage "https://frei0r.dyne.org/"
  url "https://github.com/dyne/frei0r/archive/refs/tags/v3.2.2.tar.gz"
  sha256 "d81d2828d9469cc78ba273df7f75b75adf1c6606d0c824484ba4f40d5199204a"
  license "GPL-2.0-or-later"
  compatibility_version 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8f7b9d3c1ccf2bf362a6d5971d7ec4e393879070267d7eae98f9495bed1432fe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "40cad356f2abec718d76a8c110b14978d85187202b80e681e257db0b698db0be"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "27c61bfe4bdab0c8588666d398bcddc043e1f5a3c6c1f75f2e5187e9e1f2472f"
    sha256 cellar: :any_skip_relocation, sonoma:        "aff1082a0fdf977bdedc780f30794d6012ed5b26c91b0071cfcf40807e17b257"
    sha256 cellar: :any,                 arm64_linux:   "8622d9e52b71ed1114eedfbb08b308b6eb1c5fc280a99d2f659ad20c3e9d0ad7"
    sha256 cellar: :any,                 x86_64_linux:  "cd91d6028557c05553ded8d07c4d770533518ff7631fecdbff4e322bc1902008"
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
