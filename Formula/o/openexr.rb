class Openexr < Formula
  desc "High dynamic-range image file format"
  homepage "https://www.openexr.com/"
  url "https://github.com/AcademySoftwareFoundation/openexr/archive/v3.1.11.tar.gz"
  sha256 "06b4a20d0791b5ec0f804c855d320a0615ce8445124f293616a086e093f1f1e1"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "70521fc5a3751da3ada8d80bfba75dced5201e659aeb09b05cc37fac7fc4da56"
    sha256 cellar: :any,                 arm64_monterey: "932626ddcd8e4ae704d3019f396d669261c07a51f3f8403d7e21e0ce5c5256fa"
    sha256 cellar: :any,                 arm64_big_sur:  "bf9a8ead5761f72046a61ed57202f1f15129d6bedbdfedc36394dcbaf3b22d99"
    sha256 cellar: :any,                 ventura:        "f3a6d2517f8bc62dbd2ebb46583986727fd86d6cbe4bcef7ea928d2a11c18d32"
    sha256 cellar: :any,                 monterey:       "3926469f66d680cffd798d48b216d3d7b6ff8b525a99b76094b7d644c955f0b0"
    sha256 cellar: :any,                 big_sur:        "a21a65950dafb1634796b505da7e008e8ceeb9d8b9949e1b59a753bd860932f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5a8e3e188d2a47ecfc0d7f1de24a3a142fc82bdc2bfda5c76174e51bef0f9deb"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "imath"

  uses_from_macos "zlib"

  # These used to be provided by `ilmbase`
  link_overwrite "include/OpenEXR"
  link_overwrite "lib/libIex.dylib"
  link_overwrite "lib/libIex.so"
  link_overwrite "lib/libIlmThread.dylib"
  link_overwrite "lib/libIlmThread.so"

  resource "homebrew-exr" do
    url "https://github.com/AcademySoftwareFoundation/openexr-images/raw/f17e353fbfcde3406fe02675f4d92aeae422a560/TestImages/AllHalfValues.exr"
    sha256 "eede573a0b59b79f21de15ee9d3b7649d58d8f2a8e7787ea34f192db3b3c84a4"
  end

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    resource("homebrew-exr").stage do
      system bin/"exrheader", "AllHalfValues.exr"
    end
  end
end
