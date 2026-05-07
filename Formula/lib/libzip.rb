class Libzip < Formula
  desc "C library for reading, creating, and modifying zip archives"
  homepage "https://libzip.org/"
  url "https://libzip.org/download/libzip-1.11.4.tar.xz"
  sha256 "8a247f57d1e3e6f6d11413b12a6f28a9d388de110adc0ec608d893180ed7097b"
  license "BSD-3-Clause"
  revision 2
  compatibility_version 1

  livecheck do
    url "https://libzip.org/download/"
    regex(/href=.*?libzip[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2b30e7bc40f37827ad74dd3b60600538b466cd087d260fb6e5c50256ec4d4144"
    sha256 cellar: :any,                 arm64_sequoia: "dcb8f699f1d8aac185602a5978cbd01f5ee230a9021d0237da206ec7b2889c70"
    sha256 cellar: :any,                 arm64_sonoma:  "96e048bb95d2fe5bbe224443a5d318fc1cca3c1b9899ae7af2243c08d10281c4"
    sha256 cellar: :any,                 sonoma:        "e8c2e6843c68fcda5ea2b089fe0764e90f7e5bcfaddc5a50e7d6d74fd36e5039"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0434181bd75991da053078f0272e9123e9b896132876a28dbcbf7af876dff9d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7aa413d27088cec99e7273c2776efe8732efb1b0f1b84411a2e612cb74418870"
  end

  depends_on "cmake" => :build
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "zip" => :test
  uses_from_macos "bzip2"

  on_linux do
    depends_on "openssl@3"
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
