class Frei0r < Formula
  desc "Minimalistic plugin API for video effects"
  homepage "https://frei0r.dyne.org/"
  url "https://github.com/dyne/frei0r/archive/refs/tags/v2.3.1.tar.gz"
  sha256 "dd6dbe49ba743421d8ced07781ca09c2ac62522beec16abf1750ef6fe859ddc9"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4ed74b974e7139389d18023f046b110f6130077fdf439ebc5160a74c49d201a3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8d7583afd26b8fe3ca325c3be7094cee4b11d0971540fa08c24b5f18bd6d5e11"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "544eca4e64b8b5b9ea9f1e3f8a5ff965e05550c5c817cfdba22bd4cafdccce20"
    sha256 cellar: :any_skip_relocation, ventura:        "b758ba1802d90593b19018699ff86eda41c097e26901d3416f6c5ac72eaf39d5"
    sha256 cellar: :any_skip_relocation, monterey:       "6a8da3d13c69817c2ff5cf411211209d78d57be5b9677cfff10bd640059272ea"
    sha256 cellar: :any_skip_relocation, big_sur:        "9361dbf613fa22e7098b66c5b305971a68311304eb7d46e93622f7c04d655b6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "74bba79532192e29fe85c8c125d73a7b022c84b3bd36fb655a4fc1c4ec333325"
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
