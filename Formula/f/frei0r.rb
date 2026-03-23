class Frei0r < Formula
  desc "Minimalistic plugin API for video effects"
  homepage "https://frei0r.dyne.org/"
  url "https://github.com/dyne/frei0r/archive/refs/tags/v2.5.5.tar.gz"
  sha256 "e2d01f58fa0f96a7452715f052fe452212044da4bad50bf7cc1d5d0db514a9a9"
  license "GPL-2.0-or-later"
  compatibility_version 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b4b9fdb23adb1a2929dfd626d476a3d3847c539ff7e470eabba69845171b8dad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b505077dd5ad5921fc8a3dd82dbf7b738102dedeb7de681959fb2871f12ac41e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f090c9ea017daf4fee2f80725a2cddcb6afc4d8f65d096106967609020c8dde2"
    sha256 cellar: :any_skip_relocation, sonoma:        "6ad642481f264d5e966a4a39b80121cfe612d95d106c5b2e2e1dc99db29f0c1f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "77d7dae245358f62b9785476ce1b7f1b025c3045c89d2241189ca0dd42308870"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "335d422eddda2cf9d320548778fb337d4b6b20ef40d43835876b789f964237e5"
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
