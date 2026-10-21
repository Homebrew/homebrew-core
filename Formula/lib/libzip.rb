class Libzip < Formula
  desc "C library for reading, creating, and modifying zip archives"
  homepage "https://libzip.org/"
  url "https://libzip.org/download/libzip-1.12.1.tar.xz"
  sha256 "c40062022a1963c80573d48f6070792297cecd7c6bffe3aefcac0d8b9bee8913"
  license "BSD-3-Clause"
  compatibility_version 1

  livecheck do
    url "https://libzip.org/download/"
    regex(/href=.*?libzip[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "904a47abb734c9c388a5e2cc0838b35327bbbe44f65fe0f89f7860b1c915db5e"
    sha256 cellar: :any, arm64_tahoe:       "9c216cb9fcb520b58d2c2011e4cf8f04d36d2ddb6508ef05b1bddbb55992fc47"
    sha256 cellar: :any, arm64_sequoia:     "cb823dd0266ec50ea17789d93c11ef1bcdaec9c1c7f6aa6e8cc9f8e48e0da58b"
    sha256 cellar: :any, arm64_linux:       "af29e3d236c144d411f4d2ce00be8eb350152b1f9e766459adaef3559990b85a"
    sha256 cellar: :any, x86_64_linux:      "3c741ad61d7b47ca1d29a932cde97a5d919c91265c3ea69d2df2f98860a67a21"
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
