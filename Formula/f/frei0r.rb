class Frei0r < Formula
  desc "Minimalistic plugin API for video effects"
  homepage "https://frei0r.dyne.org/"
  url "https://github.com/dyne/frei0r/archive/refs/tags/v3.5.0.tar.gz"
  sha256 "41cc8afa4991f5499cea0973be974469dcee377e67dbfbf6ca76e82b2b9bf22e"
  license "GPL-2.0-or-later"
  compatibility_version 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a03b25d34a8e7a0d0183ec9da062b77744d5809d7221a513f02c0e459467f605"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f62e1e37fdbf253a7cda8627c0539b57fff76595769374542b9bdc2d349633eb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5eef616a2ede2f846a8786054610027f8483d8c5f5aad025100bf5fe7ec4dad3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "677444bb7fa85f3cbb354edbe0c3cce4de0e2d84cfd289007aa008127f4ee6ec"
    sha256 cellar: :any_skip_relocation, sonoma:            "e25204514624becd13ca144f764ac1bb92c81e219b843e2750df4d5ecc42814c"
    sha256 cellar: :any,                 arm64_linux:       "50e97373cb446c29c76763fbc29915b8e15657144ff349703056146f60ee2530"
    sha256 cellar: :any,                 x86_64_linux:      "fcff0b2a4af65da0c9165db0e571aa00ede0135831e6d5a4fc3e45304bea2260"
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
