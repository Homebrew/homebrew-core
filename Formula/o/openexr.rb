class Openexr < Formula
  desc "High dynamic-range image file format"
  homepage "https://www.openexr.com/"
  url "https://github.com/AcademySoftwareFoundation/openexr/archive/refs/tags/v3.3.5.tar.gz"
  sha256 "cb0c88710c906c9bfc59027eb147e780d508c7be1a90b43af3ec9e3c2987b70d"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f12f6e8a339ab66b6269da2b6376d49fec5a8b5bdeae7c0ebe89cd2b0b5a69a1"
    sha256 cellar: :any,                 arm64_sonoma:  "2aa025ea22311fd122cb6ed3c8d2fb298353fe6eaf9f30f29494e6e05db2e124"
    sha256 cellar: :any,                 arm64_ventura: "d9aa2b4340000de4608f71eb1840229ddc6300f2a3ee4a07db12649b4a51cd24"
    sha256 cellar: :any,                 sonoma:        "d89f7a04ce90650e5210b6bc95731c749b7f53b09ac281d1fe651302c2362137"
    sha256 cellar: :any,                 ventura:       "1eb8efc8146368b564cf64e012cb047ea58430102c7ef63f679fdb2f3eab9083"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2bac00e20b41e26ab2827cc2fa5ab717720bc3b62148afa1632dc950cb3d3e0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "00b60166006a6710230bfdee0688eafea14f2e34a9a80a3d52a7a1ec465be5a1"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  depends_on "imath"
  depends_on "libdeflate"

  uses_from_macos "zlib"

  # These used to be provided by `ilmbase`
  link_overwrite "include/OpenEXR"
  link_overwrite "lib/libIex.dylib"
  link_overwrite "lib/libIex.so"
  link_overwrite "lib/libIlmThread.dylib"
  link_overwrite "lib/libIlmThread.so"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    resource "homebrew-exr" do
      url "https://github.com/AcademySoftwareFoundation/openexr-images/raw/f17e353fbfcde3406fe02675f4d92aeae422a560/TestImages/AllHalfValues.exr"
      sha256 "eede573a0b59b79f21de15ee9d3b7649d58d8f2a8e7787ea34f192db3b3c84a4"
    end

    resource("homebrew-exr").stage do
      system bin/"exrheader", "AllHalfValues.exr"
    end
  end
end
