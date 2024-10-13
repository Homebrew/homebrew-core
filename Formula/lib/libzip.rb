class Libzip < Formula
  desc "C library for reading, creating, and modifying zip archives"
  homepage "https://libzip.org/"
  url "https://libzip.org/download/libzip-1.11.1.tar.xz", using: :homebrew_curl
  sha256 "721e0e4e851073b508c243fd75eda04e4c5006158a900441de10ce274cc3b633"
  license "BSD-3-Clause"

  livecheck do
    url "https://libzip.org/download/"
    regex(/href=.*?libzip[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8edff4d317c07b10668d8966db23bf568b55cfcf1b52a772fd5bde020d3c4753"
    sha256 cellar: :any,                 arm64_sonoma:  "3dce66ccd6891fa5af53a195d2dced3a3ef1c4738f3f57e288c4fd5d1cf02d73"
    sha256 cellar: :any,                 arm64_ventura: "56225b61b948c8f44ab4818bde528c3c4c84f90c02362d13f215a726961112a9"
    sha256 cellar: :any,                 sonoma:        "9a8d6612ce96978694b6e309473a230cc1e338fedca339f9366010670880c50b"
    sha256 cellar: :any,                 ventura:       "d1887f3ee534207c478ea5bad5ff822bcbdfa247c1c5b59957e8ff0e41d0d2ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "03bf2c4dd2b97ab8a4e111bedf1f58074b0f859874cbbbb1c9b158c3e3f6d1ca"
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
    crypto_args = %w[
      -DENABLE_GNUTLS=OFF
      -DENABLE_MBEDTLS=OFF
    ]
    crypto_args << "-DENABLE_OPENSSL=OFF" if OS.mac? # Use CommonCrypto instead.
    system "cmake", ".", *std_cmake_args,
                         *crypto_args,
                         "-DBUILD_REGRESS=OFF",
                         "-DBUILD_EXAMPLES=OFF"
    system "make", "install"
  end

  test do
    touch "file1"
    system "zip", "file1.zip", "file1"
    touch "file2"
    system "zip", "file2.zip", "file1", "file2"
    assert_match(/\+.*file2/, shell_output("#{bin}/zipcmp -v file1.zip file2.zip", 1))
  end
end
