class Jxrlib < Formula
  desc "Tools for JPEG-XR image encoding/decoding"
  homepage "https://tracker.debian.org/pkg/jxrlib"
  url "http://deb.debian.org/debian/pool/main/j/jxrlib/jxrlib_1.2~git20170615.f752187.orig.tar.xz"
  sha256 "3e3c9d3752b0bbf018ed9ce01b43dcd4be866521dc2370dc9221520b5bd440d4"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "488ffec6b9614adcd0b07349e71fc87243b142a59004a511da051756d05f299e"
    sha256 cellar: :any,                 arm64_monterey: "029cfa77cb1594e9831eb94173bfd0bcef7a5a8eb24ff44bc7e367ab2617c936"
    sha256 cellar: :any,                 arm64_big_sur:  "b2c8d472fa9c0a69763f9df5ddf4a807a5580cc5da7cdd1497f09f8c35dd6df5"
    sha256 cellar: :any,                 ventura:        "f927ae6b48154efe4ffbfffe93d5088b54c14717eb3e2c562d54194da8ae2c94"
    sha256 cellar: :any,                 monterey:       "fdf76897a19643eae22606dfd051a4e2be38963f78ad95c64c6661355aee6730"
    sha256 cellar: :any,                 big_sur:        "e676ef53d5cf3ae6ec8bdd7b1b75846e1f06fc24521518a8cb10f6c7f239295c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dfb64124039eccbb5481c3b214b0e1c539b0310d8052227fdd6faf094b07438b"
  end

  depends_on "cmake" => :build

  # Enable building with CMake. Adapted from Debian patch.
  patch do
    url "https://raw.githubusercontent.com/Gcenx/macports-wine/1b310a17497f9a49cc82789cc5afa2d22bb67c0c/graphics/jxrlib/files/0001-Add-ability-to-build-using-cmake.patch"
    sha256 "beebe13d40bc5b0ce645db26b3c8f8409952d88495bbab8bc3bebc954bdecffe"
  end

  def install
    inreplace "CMakeLists.txt", "@VERSION@", version.to_s
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    bmp = "Qk06AAAAAAAAADYAAAAoAAAAAQAAAAEAAAABABgAAAAAAAQAAADDDgAAww4AAAAAAAAAAAAA////AA==".unpack1("m")
    infile  = "test.bmp"
    outfile = "test.jxr"
    File.binwrite(infile, bmp)
    system bin/"JxrEncApp", "-i", infile,  "-o", outfile
    system bin/"JxrDecApp", "-i", outfile, "-o", infile
  end
end
