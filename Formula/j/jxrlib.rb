class Jxrlib < Formula
  desc "Tools for JPEG-XR image encoding/decoding"
  homepage "https://tracker.debian.org/pkg/jxrlib"
  url "http://deb.debian.org/debian/pool/main/j/jxrlib/jxrlib_1.2~git20170615.f752187.orig.tar.xz"
  version "1.2_git20170615-f752187.orig"
  sha256 "3e3c9d3752b0bbf018ed9ce01b43dcd4be866521dc2370dc9221520b5bd440d4"
  license "BSD-2-Clause"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7717bc3eed54f09fafdeb39e3a061343736a4ebf778e7de16ab3f9f1c8f1c7f6"
    sha256 cellar: :any,                 arm64_ventura:  "aec102465350547c4a3437747738433c8e16dcda9ce615120335e3f881682e44"
    sha256 cellar: :any,                 arm64_monterey: "58453b7b2a1705876b9e5677803fa5186db134fc89a1d580e771e35cbcfc2601"
    sha256 cellar: :any,                 arm64_big_sur:  "9b6f4241a43f2311bddfc1279cd05ce6ac81ab4f735b57898cb1795e99c54230"
    sha256 cellar: :any,                 sonoma:         "0c0541f38b9a38e87ad93d3c5fa3e00307a5780a2dca40199c9a749e4f5f64e1"
    sha256 cellar: :any,                 ventura:        "4a1ac556c9424cef5bdb2f64154e63f4ca956598f6178b99b0ff6f58859fcfee"
    sha256 cellar: :any,                 monterey:       "d2388230a8788594452d1b6c301821a73b33dfa00643abe30cf660ee12fd2848"
    sha256 cellar: :any,                 big_sur:        "d0b02e434b4baae0aeb64e769d5adacb5c0dd4597758958c8aaafa54ea1585c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b4e90e6ae7c545f08907c3bc4961348447f6a77d6cc182c35b0f526dd223fd3b"
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
