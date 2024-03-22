class Frei0r < Formula
  desc "Minimalistic plugin API for video effects"
  homepage "https://frei0r.dyne.org/"
  url "https://github.com/dyne/frei0r/archive/refs/tags/v2.3.2.tar.gz"
  sha256 "304291e0ecb456a8b054fe04e14adc50ace54d0223b7b29165ff5343e820ef9d"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "69b7048afec9dc74c1836c776ded9155ffb0b50bc202d8915495347ece001e00"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fc73fd01cdef1a20b04f7b5eb44a5497401e319c6f5415ee43d36d0aa1c313b3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eafbb229d0de96e9cb4c17f82cc728ef1cd48ae236ce827b86e6784aa218d5d0"
    sha256 cellar: :any_skip_relocation, sonoma:         "72fe8f2e716fe7570adb00436b2d90b7c8babe305f189f3e846c0dfc45fd06b5"
    sha256 cellar: :any_skip_relocation, ventura:        "5ab3357869b923be9ec82787503f7fd3d8c9d4902db74a3de62220b4d97dedc0"
    sha256 cellar: :any_skip_relocation, monterey:       "477e296e444d404799de7808506530a8690cdb961c99add402a3a3cc710fa6ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6193b51ed91b0651429d73d686060a8ff72e4fd68b1a88df05f530797eb3c336"
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
    (testpath/"test.c").write <<~EOS
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
    EOS
    system ENV.cc, "-L#{lib}", "test.c", "-o", "test"
    system "./test"
  end
end
