class Frei0r < Formula
  desc "Minimalistic plugin API for video effects"
  homepage "https://frei0r.dyne.org/"
  url "https://github.com/dyne/frei0r/archive/refs/tags/v2.4.0.tar.gz"
  sha256 "6b3491ee65c775b251ecd0ba2cb86955ca2469de47c73718170442732cb9ce75"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "63f08e2448e24eeb11aef1f06263723fa8a56e14f928ac4cda08af05a0d71a7f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "260b59f5cdef89305e1d51b61516e5714d6ebc2253ff90c47b634897b17d0161"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e51686ec965010822c4fabba4c0995efcfa4b7cd654d91aed489f51314127466"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0bc1c5a6d8debeed480c72886f132b24031a3d89e102eec0962bef6820e934d3"
    sha256 cellar: :any_skip_relocation, sonoma:        "3d720cd8ebb47d97dd86e53908e1ede2396ba0c1438970d270a2bb82f7faf49d"
    sha256 cellar: :any_skip_relocation, ventura:       "57a6eaa5defbe47d71da8fc2f6e18d34e1ff1615c99bb9b243aa00e2aebc1638"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "979d93b3cffdc26d00434b11a32b4d0b4a11701cc536334ce7fd76e17783a638"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b0ed7726e7152a3e798c43841be1ac4b9ad6b33bb043fb0b6018df3fbaecbd47"
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
