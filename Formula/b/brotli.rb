class Brotli < Formula
  desc "Generic-purpose lossless compression algorithm by Google"
  homepage "https://github.com/google/brotli"
  url "https://github.com/google/brotli/archive/refs/tags/v1.2.0.tar.gz"
  mirror "http://fresh-center.net/linux/misc/brotli-1.2.0.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/brotli-1.2.0.tar.gz"
  sha256 "816c96e8e8f193b40151dad7e8ff37b1221d019dbcb9c35cd3fadbfe6477dfec"
  license "MIT"
  head "https://github.com/google/brotli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "71ffd30ccd74a9f28cfb210c21fcdc1aa5fec79e23ad2264b6dbceb73437601f"
    sha256 cellar: :any,                 arm64_sequoia: "b8e388c96be5a63a46e0335c390fecb20dda7adb1368a2ba0209b38cae17c708"
    sha256 cellar: :any,                 arm64_sonoma:  "46b1cc7ef8ba325e56f7363de1068a84449dac940187dd2290a75e7008b3b4e1"
    sha256 cellar: :any,                 sonoma:        "c9d272f3ac33b730d548da14ca323e8b4e0185273a6c85b0f12a4bbcd9f684af"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "485e0a6a74702cbe57819b32177bfb81e0195a71f52a16bab84b03529a672cf3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d97618daaa84b66bc783888297f1765eb6f60e6a78e9b7c2ba0406889c159c05"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_RPATH=#{rpath}", *std_cmake_args
    system "cmake", "--build", "build", "--verbose"
    system "ctest", "--test-dir", "build", "--verbose"
    system "cmake", "--install", "build"
    system "cmake", "-S", ".", "-B", "build-static", "-DBUILD_SHARED_LIBS=OFF", *std_cmake_args
    system "cmake", "--build", "build-static"
    lib.install buildpath.glob("build-static/*.a")
  end

  test do
    (testpath/"file.txt").write("Hello, World!")
    system bin/"brotli", "file.txt", "file.txt.br"
    system bin/"brotli", "file.txt.br", "--output=out.txt", "--decompress"
    assert_equal (testpath/"file.txt").read, (testpath/"out.txt").read
  end
end
