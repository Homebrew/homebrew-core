class Geographiclib < Formula
  desc "C++ geography library"
  homepage "https://geographiclib.sourceforge.io/"
  url "https://github.com/geographiclib/geographiclib/archive/refs/tags/r2.5.tar.gz"
  sha256 "4b646358189799491e669f0de5072e94e3988d4a7486823344d182d57665ed35"
  license "MIT"
  head "https://github.com/geographiclib/geographiclib.git", branch: "main"

  livecheck do
    url :stable
    regex(/^r(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "467cd9d17e3c199e4820960b4b0a063aa2983867b74652371daa2c0d7a19b58b"
    sha256 cellar: :any,                 arm64_sonoma:  "dd1633f4ab6ddbbcb696f5b71b7d50b3079a92d3a264cf15891beb55d2f81cd5"
    sha256 cellar: :any,                 arm64_ventura: "2c1f50b78d5d698fc21829a450d03a1ff88e574f20390708430d2450f2f0b344"
    sha256 cellar: :any,                 sonoma:        "bf8f89352e0aa0f3fb5ab24a92aed7c82e3a81eca7d08b84526dded1429d6e6d"
    sha256 cellar: :any,                 ventura:       "80d6b616f1202598f559245ccd0e0e534bd3474c794f5e1c74d667b05812f2fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d1d2871a31e2f92dbdbfdcce3adbf7029af7abc97c397b054fc9974bc8f698c2"
  end

  depends_on "cmake" => :build

  def install
    args = ["-DEXAMPLEDIR="]
    args << "-DCMAKE_OSX_SYSROOT=#{MacOS.sdk_path}" if OS.mac?
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"GeoConvert", "-p", "-3", "-m", "--input-string", "33.3 44.4"
  end
end
