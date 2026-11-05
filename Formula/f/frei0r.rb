class Frei0r < Formula
  desc "Minimalistic plugin API for video effects"
  homepage "https://frei0r.dyne.org/"
  url "https://github.com/dyne/frei0r/archive/refs/tags/v3.7.0.tar.gz"
  sha256 "352e1e583865a0bb0a7404302a14cdfb30e26c2cf1e8724605bd29067d089159"
  license "GPL-2.0-or-later"
  compatibility_version 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0a6ca8fb041ef4eb240b772aa5c07fa84aa2e33b97ab6d072a0b50efa76cb642"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "482020519fe945975c7cac2f2eb88fd7f5c11b4a74e64078c6c1efa74fe8b532"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9282c476ed3636265f089a368f854b12ebb8a61a19d8a5c018454b6798ed89e0"
    sha256 cellar: :any,                 arm64_linux:       "4d132442cab035b37db6b7d83de3b3eeeaf0b569230ab8a4a9771ea104305a02"
    sha256 cellar: :any,                 x86_64_linux:      "39b132d3cbcaf2d3486e537c29aa6007d2f02ef1b79cafae869b77eb10aeff96"
  end

  depends_on "cmake" => :build

  deny_network_access!

  def install
    # Skip the Linux-only `shadert0y` filter, which needs OpenGL/EGL from `mesa`
    inreplace "src/filter/CMakeLists.txt", "add_subdirectory (shadert0y)", ""

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
