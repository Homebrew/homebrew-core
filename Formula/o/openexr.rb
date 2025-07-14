class Openexr < Formula
  desc "High dynamic-range image file format"
  homepage "https://www.openexr.com/"
  url "https://github.com/AcademySoftwareFoundation/openexr/archive/refs/tags/v3.3.4.tar.gz"
  sha256 "63abac7c52f280e3e16fc868ac40e06449733bb19179008248ae7e34e4f19824"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "35e994d7b07e1f974f262692dd2e9c17c081d6bc3beb9dc62391ec6ed726c08e"
    sha256 cellar: :any,                 arm64_sonoma:  "6a4745c14f5b3fa0b950427c974c535c6c101ebfe4b78a3b259031b714d5f4ab"
    sha256 cellar: :any,                 arm64_ventura: "d5e969d9d4e1cbfb293d3ef06dac589ffa1c3bc5a4dc4039d94fb3dee16a340a"
    sha256 cellar: :any,                 sonoma:        "981b5bd76b31301fed78add438c4987ae6c56f119608d213125b16d7788f9f9e"
    sha256 cellar: :any,                 ventura:       "a14f6e9a69ac9a9a184bc2262d36c6307e1a8fd31aa1e1f177fb8cb5bbd8741a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bc5050dd3533df0a28a6cb5351bd46efe8d0347b2522aa65139b25e4be018479"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e34797a30de05b55b2b2fff6dc0bf1b12b1248e4fe6f251d5da63e8f63f89c6"
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
