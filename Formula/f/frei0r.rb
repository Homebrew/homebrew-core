class Frei0r < Formula
  desc "Minimalistic plugin API for video effects"
  homepage "https://frei0r.dyne.org/"
  url "https://github.com/dyne/frei0r/archive/refs/tags/v3.7.0.tar.gz"
  sha256 "352e1e583865a0bb0a7404302a14cdfb30e26c2cf1e8724605bd29067d089159"
  license "GPL-2.0-or-later"
  compatibility_version 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0286dfed7a2f536f50cafc92f65fee1beb02bf9f5386330a688f468a4a9a1b61"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "af37e342a6a9cbb2b7257e9e9b301a816941487b532124d8c9ad724392214dfb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8accb53f3e798d88313ac7e054ea75a589bb61811068480ceff6d28b2f339511"
    sha256 cellar: :any,                 arm64_linux:       "e3ef8a32350d152741e3b6e043ec313ad656995634de728a5b7de47fb00f5e85"
    sha256 cellar: :any,                 x86_64_linux:      "5143f04f53bf6c35b7922f9487976d0157d7d5dc4dd40caa46195f54b842ee8b"
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
