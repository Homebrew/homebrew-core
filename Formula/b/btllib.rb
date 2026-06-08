class Btllib < Formula
  desc "Bioinformatics Technology Lab common code library"
  homepage "https://github.com/bcgsc/btllib"
  url "https://github.com/bcgsc/btllib/releases/download/v1.7.8/btllib-1.7.8.tar.gz"
  sha256 "cd213d20a971ae3441551dd61b0e46a08559e3d9da19cb59ee8dc3397807f121"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c97fa830bec809a259eafea78ad8d575fdd39246e300a094db6e9e6828b20cb1"
    sha256 cellar: :any,                 arm64_sequoia: "b199cb1787d5f6650c6ba33e3fe3d84ea4d4bbada0df36cc8f2a79c751eeb2a2"
    sha256 cellar: :any,                 arm64_sonoma:  "b27993864f2a1b481c89020aa6b2384a4c76a2373213038d97cc1d82b29a593d"
    sha256 cellar: :any,                 sonoma:        "f265eb6beb110c04dfdb3aa85fbf23016e7b8a8ed4943c3d96da32aebe066905"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e6242f4b4c44840b063c1a159c3afaa12ec00c8044c0a632149b2db29829987b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a40c45bac82f1fdfc8c01fa149515964b3e509a77eee0d47a1900aa738778305"
  end

  depends_on "cmake" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "python@3.14" => :build

  on_macos do
    depends_on "libomp"
  end

  # Apply FreeBSD patch to fix build with newer Clang, https://github.com/simongog/sdsl-lite/issues/462
  patch :p0 do
    url "https://raw.githubusercontent.com/freebsd/freebsd-ports/af74f60a871e4a5aa7aea787fc235a2cb760e764/devel/sdsl-lite/files/patch-include_sdsl_louds__tree.hpp"
    sha256 "84aef67058947044c40032ac39d9b6d1b8a285c581f660d565cd23aaa4beade7"
    directory "subprojects/sdsl-lite"
  end

  def install
    # Workaround for CMake 4 compatibility
    ENV["CMAKE_POLICY_VERSION_MINIMUM"] = "3.5"

    args = %w[-Db_ndebug=true -Db_coverage=false]
    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include "btllib/seq.hpp"

      #include <string>

      int main()
      {
        std::string seq = "ACGTACACTGGACTGAGTCT";
        std::string rc = "AGACTCAGTCCAGTGTACGT";
        if (btllib::get_reverse_complement(seq) != rc) {
          return 1;
        }
        return 0;
      }
    CPP
    system ENV.cxx, "test.cpp", "-std=c++11", "-I#{include}", "-L#{lib}", "-lbtllib", "-o", "test"
    system "./test"
  end
end
