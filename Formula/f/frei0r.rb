class Frei0r < Formula
  desc "Minimalistic plugin API for video effects"
  homepage "https://frei0r.dyne.org/"
  url "https://github.com/dyne/frei0r/archive/refs/tags/v3.1.3.tar.gz"
  sha256 "dcf290cdfbe583d007c300aa7733c9350ed957a0e30ca897a5c098875b8aa5dc"
  license "GPL-2.0-or-later"
  compatibility_version 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cb1baea44ebcb0326f0dba61097f698ecff3e4f285fe762a2abe89e8c00f3686"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "335c72440b4b11ccde51af02d725619aa6575c55e030dbce2dd01064bb14d3a2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "78497853c70fc0008cd05b167286a8af83e407328a40ded6757a5e4809755a1f"
    sha256 cellar: :any_skip_relocation, sonoma:        "e30e9aa5de02512b280e3759cb3c31a7950f54cfb2958ae8ed4267ec822f95f9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7e81d5aaa75f8af15983363ff563aa83206fff5eccc6a6aec922b817f6bdb859"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "142646aafd63ccbe84e942106a5697a470cd0a38837b9eab50670635eda1494e"
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
