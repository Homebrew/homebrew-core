class Libzip < Formula
  desc "C library for reading, creating, and modifying zip archives"
  homepage "https://libzip.org/"
  url "https://libzip.org/download/libzip-1.12.tar.xz"
  sha256 "376908d0f0fda13180a19fdc4f7062a1abfb59e09ca07a392d361253b8e60c2b"
  license "BSD-3-Clause"
  revision 1
  compatibility_version 1

  livecheck do
    url "https://libzip.org/download/"
    regex(/href=.*?libzip[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "c1b0d545310f9986d3086363f1b79f5066b75eeff9cd3588d21ff925ded0fb24"
    sha256 cellar: :any, arm64_tahoe:       "24a451df5142724086a16439fac719df1b0da9fa0c68a1bfe0133f5db51f05e6"
    sha256 cellar: :any, arm64_sequoia:     "925c64a198b759de45cbe32aeeae0854560278363e43c9b538e42c6623002c7f"
    sha256 cellar: :any, arm64_linux:       "2aba53af620dc970f5ee4d354c27ebca615eb2960e3779445e8bf5e5bb7686b5"
    sha256 cellar: :any, x86_64_linux:      "fd69a2649a8c1dd235d5a8e1cdbef7d60fcdcb76704d99e18cd1d3fdf26a9f21"
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
