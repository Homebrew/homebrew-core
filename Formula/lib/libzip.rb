class Libzip < Formula
  desc "C library for reading, creating, and modifying zip archives"
  homepage "https://libzip.org/"
  url "https://libzip.org/download/libzip-1.11.3.tar.xz"
  sha256 "9509d878ba788271c8b5abca9cfde1720f075335686237b7e9a9e7210fe67c1b"
  license "BSD-3-Clause"

  livecheck do
    url "https://libzip.org/download/"
    regex(/href=.*?libzip[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d047ed69c28d812b43092cdc11a95ebfb10c260294088b10c9e5c4013f8f7729"
    sha256 cellar: :any,                 arm64_sonoma:  "0eef871bcff5568c941e603285f699b520fb0918876ab15129047b1eae8919c1"
    sha256 cellar: :any,                 arm64_ventura: "a5f5cad9a74903117c3168e95aed359880001176cec4012caf3347768e4653b4"
    sha256 cellar: :any,                 sonoma:        "e3a656692093ac165b0c07c830cc053dffc85f916168b584538d02c4c0205692"
    sha256 cellar: :any,                 ventura:       "6b4c562f07821355fd8c641a42da8fde595ade1c1a26ab76c218e3394e6f318f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "03718195387870f33ceb6951a3caa487d2325823b23034811f49b4ba0fe71521"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ce5e38e6c13fcce7176c9acd84abdd28d495a1377b1e9b1d622ebdefebe11f7"
  end

  depends_on "cmake" => :build
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "zip" => :test
  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  on_linux do
    depends_on "openssl@3"
  end

  conflicts_with "libtcod", because: "libtcod and libzip install a `zip.h` header"

  def install
    args = %w[
      -DENABLE_GNUTLS=OFF
      -DENABLE_MBEDTLS=OFF
      -DBUILD_REGRESS=OFF
      -DBUILD_EXAMPLES=OFF
    ]
    args << "-DENABLE_OPENSSL=OFF" if OS.mac? # Use CommonCrypto instead.

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    touch "file1"
    system "zip", "file1.zip", "file1"
    touch "file2"
    system "zip", "file2.zip", "file1", "file2"
    assert_match(/\+.*file2/, shell_output("#{bin}/zipcmp -v file1.zip file2.zip", 1))
  end
end
