class Jxrlib < Formula
  desc "Tools for JPEG-XR image encoding/decoding"
  homepage "https://archive.codeplex.com/?p=jxrlib"
  url "https://deb.debian.org/debian/pool/main/j/jxrlib/jxrlib_1.1.orig.tar.gz"
  sha256 "c7287b86780befa0914f2eeb8be2ac83e672ebd4bd16dc5574a36a59d9708303"
  license "BSD-2-Clause"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "54cfa4c3ba6f80ae22012ceb65b6c50340489d6a8cf99b0abd26a93e4be16628"
    sha256 cellar: :any_skip_relocation, big_sur:       "8cd0235dd1a6537562f6c7939ffd99bab6568eab5b72326ef6670ee1299fe5dc"
    sha256 cellar: :any_skip_relocation, catalina:      "51c5db55544b873ddbb50eb5681ab3d6ce1552df452bc31f3865d33e36176888"
    sha256 cellar: :any_skip_relocation, mojave:        "923729f8257b2ff225affe4a2a822f2dd40e799ca45be9ac423f04b5e4e603f0"
    sha256 cellar: :any_skip_relocation, high_sierra:   "6d24053d591022594ab92f880c56da4057a9e4f8d8ecb6f942e3558900385def"
    sha256 cellar: :any_skip_relocation, sierra:        "0eb8602ab389d9fff5bce803b085af322309592dc41aa0902b223e353a9f8abc"
    sha256 cellar: :any_skip_relocation, el_capitan:    "47c308b47ec8227d813a21c8092b32ada9b7f862aef102bf619d6bb19f0144e1"
    sha256 cellar: :any_skip_relocation, yosemite:      "0dae977caf9e34289c9dd09f7e12bdf7158ccc42d9fa2dc00b4164b82c1caf3f"
  end

  depends_on "cmake" => :build

  # Enable building with CMake. Adapted from Debian patch.
  patch do
    url "https://raw.githubusercontent.com/Gcenx/macports-wine/1b310a17497f9a49cc82789cc5afa2d22bb67c0c/graphics/jxrlib/files/0001-Add-ability-to-build-using-cmake.patch"
    sha256 "beebe13d40bc5b0ce645db26b3c8f8409952d88495bbab8bc3bebc954bdecffe"
  end

  def install
    inreplace "CMakeLists.txt", "@VERSION@", version
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    bmp = "Qk06AAAAAAAAADYAAAAoAAAAAQAAAAEAAAABABgAAAAAAAQAAADDDgAAww4AAAAAAAAAAAAA////AA==".unpack1("m")
    infile  = "test.bmp"
    outfile = "test.jxr"
    File.open(infile, "wb") { |f| f.write bmp }
    system bin/"JxrEncApp", "-i", infile,  "-o", outfile
    system bin/"JxrDecApp", "-i", outfile, "-o", infile
  end
end
