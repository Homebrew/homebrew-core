class Libzip < Formula
  desc "C library for reading, creating, and modifying zip archives"
  homepage "https://libzip.org/"
  url "https://libzip.org/download/libzip-1.11.4.tar.xz"
  sha256 "8a247f57d1e3e6f6d11413b12a6f28a9d388de110adc0ec608d893180ed7097b"
  license "BSD-3-Clause"
  revision 1
  compatibility_version 1

  livecheck do
    url "https://libzip.org/download/"
    regex(/href=.*?libzip[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "c290af28bf46ce0ad37565135483609bc1e1de0e71e9edf1b9b9182e75a6f2d6"
    sha256 cellar: :any,                 arm64_sequoia: "a7ce0f0b76c3fa4957234b101576f601438ffef7769341cf1ca000cf90960ad6"
    sha256 cellar: :any,                 arm64_sonoma:  "6ef7ac3386de9d85713e1f7e62c7d1edff6bcd7833281b90fbfd7b191df7b2f8"
    sha256 cellar: :any,                 sonoma:        "f55c42e37daf714f4283b77f56b25ccb3288c73b97b15831b3cb5377652d3376"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4eff813d4699d88b656864b98d6a5ca89aa651a3ee48f6ee2122ff17b4880973"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "19ea3f62d46ce3026e49c8c38bf12f1e221b6a1bae5e787d138b32c1160f47bb"
  end

  depends_on "cmake" => :build
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "zip" => :test
  uses_from_macos "bzip2"

  on_linux do
    depends_on "openssl@4"
    depends_on "zlib-ng-compat"
  end

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
