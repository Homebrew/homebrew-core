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
    sha256 cellar: :any, arm64_golden_gate: "426666aa1ce51d104df05a033fd4b8703aed9f28e7e93059599156fae36864af"
    sha256 cellar: :any, arm64_tahoe:       "39fb0e4becd26d962f0c5751f2b4cebc8278b69a67ccfe5c885f59b162ead6be"
    sha256 cellar: :any, arm64_sequoia:     "c40797be605cd50d45fdb8d82f6fb82a2b7a59069655329f1e3fb570a91c3a61"
    sha256 cellar: :any, arm64_linux:       "3281935bee686781da473b8a85425e8b766b03f86d2b417ab72f82d346421ebd"
    sha256 cellar: :any, x86_64_linux:      "6ad9996fdf8d680a12ed3d84fe0589cf667320635e79b5efef8eb647fd029868"
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
