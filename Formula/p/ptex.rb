class Ptex < Formula
  desc "Texture mapping system"
  homepage "https://ptex.us/"
  url "https://github.com/wdas/ptex/archive/refs/tags/v2.5.1.tar.gz"
  sha256 "6b4b55f562a0f9492655fcb7686ecc335a2a4dacc1de9f9a057a32f3867a9d9e"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b9ad545c0561cf637d82a5dff6e0c783c707bca219cf361a96390d0ff7484780"
    sha256 cellar: :any,                 arm64_sequoia: "25ef8e59f1281d492ed40390e8408f9f1104f1378bf0ee1e67daaff4ade4abab"
    sha256 cellar: :any,                 arm64_sonoma:  "c30eae1e67e46837fd7b8b42e6cd1559747c725d9bfc79520f1962566c5645e2"
    sha256 cellar: :any,                 sonoma:        "b377aec3cfbafdb380aaf0b8efe83f305e178681836192476669322c31afc523"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6678a7e585381373ea5f21bf5d1833417a8d47dc30a0e0d2b48e6dd99434a8b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8fdf8e1c4e191abd2553ffdc6dd9c57eee384d41a0edec03fca0c0958501954d"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "libdeflate"

  uses_from_macos "zlib"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_CXX_STANDARD=17", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    resource "homebrew-wtest" do
      url "https://raw.githubusercontent.com/wdas/ptex/v2.4.2/src/tests/wtest.cpp"
      sha256 "95c78f97421eac034401b579037b7ba4536a96f4b356f8f1bb1e87b9db752444"
    end

    testpath.install resource("homebrew-wtest")
    system ENV.cxx, "wtest.cpp", "-o", "wtest", "-I#{opt_include}", "-L#{opt_lib}", "-lPtex"
    system "./wtest"
    system bin/"ptxinfo", "-c", "test.ptx"
  end
end
