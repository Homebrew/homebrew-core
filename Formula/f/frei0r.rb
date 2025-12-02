class Frei0r < Formula
  desc "Minimalistic plugin API for video effects"
  homepage "https://frei0r.dyne.org/"
  url "https://github.com/dyne/frei0r/archive/refs/tags/v2.5.0.tar.gz"
  sha256 "c511aeb51faeb0de2afe47327c30026d5b76ccc910a0b93d286029f07d29c656"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2b41c5ad26553c1885d8d5a2f528ecb1459655c140501e6885be3e83838ae50d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "64fe8ea2a3289791c0ecbab17632b659a0a0c3c2c3cc9129d9dad760e35729b9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3d37eb8709cbf2a605b8750d354526aea3a90cfeccd7fbd3f43a997e3a99be0c"
    sha256 cellar: :any_skip_relocation, sonoma:        "e567db0ed4ceeaea6954374249b01e5da74cbd7bae67a3dccb08d6ccefe1dc9f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "26ddbf1764a5a0f0bd842758ae93b8f1d601108387866162b8cad47624938ecd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5ba3a2fee270b6eed1deca727b739587a46eaefee79a06badb7c2d51acf939ec"
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
