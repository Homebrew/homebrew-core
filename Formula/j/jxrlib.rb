class Jxrlib < Formula
  desc "Tools for JPEG-XR image encoding/decoding"
  homepage "https://tracker.debian.org/pkg/jxrlib"
  url "http://deb.debian.org/debian/pool/main/j/jxrlib/jxrlib_1.2~git20170615.f752187.orig.tar.xz"
  version "1.2_git20170615-f752187.orig"
  sha256 "3e3c9d3752b0bbf018ed9ce01b43dcd4be866521dc2370dc9221520b5bd440d4"
  license "BSD-2-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "ad134074333a2b08fb5381ebb7d050451d1a5d632dff810feec5456e15a82a93"
    sha256 cellar: :any,                 arm64_monterey: "f343ef9670df408cb127fd016246695f5a123b3e71a66cdade3692bd5e5ced30"
    sha256 cellar: :any,                 arm64_big_sur:  "5a50f665f18598f468eb24546bb968e008e3ef4fe7561625bf5e4ca1973c5080"
    sha256 cellar: :any,                 ventura:        "22590456157a808cc093e7c9f8a56f244413cc4a88d95e43756394572591508a"
    sha256 cellar: :any,                 monterey:       "b755f19b7ff8de43480760bbe9dc58f974005e84d7974c8e03ded262ca80e91e"
    sha256 cellar: :any,                 big_sur:        "19c64d9570f903b1e5a08f5cb78d9c1b895acd5614e09073389f9fc5558fddd3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5ceb2e8f381a0d231d0f014d85dfad4e690ff5f01bdc599a4ac415a72adaf42e"
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
