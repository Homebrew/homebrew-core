class Mosh < Formula
  desc "Remote terminal application"
  homepage "https://mosh.org"
  url "https://github.com/mobile-shell/mosh/releases/download/mosh-1.4.0/mosh-1.4.0.tar.gz"
  sha256 "872e4b134e5df29c8933dff12350785054d2fd2839b5ae6b5587b14db1465ddd"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "270731aad2028b9dab43ed87dae0b650880f34aa059a3584a0b6f7609c7e8453"
    sha256 cellar: :any,                 arm64_monterey: "2780be65178f382963fd1759ff1b9df15807cc30b4a7cab5a766da1a4157ef49"
    sha256 cellar: :any,                 arm64_big_sur:  "5b52e78e946518d87bbac09cd450188e65869ebab91dfb7617534c5c913b1b01"
    sha256 cellar: :any,                 ventura:        "77609ce1bdfddcc59df543c61ac2728ea17b8ab349839e1fa5291f9c4a574d95"
    sha256 cellar: :any,                 monterey:       "3e096f0100dd45fd8e292c59fb9c1fe42af3e6edfe3f662abb3cdb8dda8b508b"
    sha256 cellar: :any,                 big_sur:        "26537bd45fcc9a86274b84b9f6b741ffb677fa769c3be1a0d2dd568aa0447986"
    sha256 cellar: :any,                 catalina:       "2df281372623a61e3a9a7d3c795f4aefa0d2514da4c545f7c86646b28205c918"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f657bf329013d80922dc46fdbf4ec6303a5d665826affc0008bcb0deb2da6f3d"
  end

  head do
    url "https://github.com/mobile-shell/mosh.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "protobuf"

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  on_linux do
    depends_on "openssl@1.1" # Uses CommonCrypto on macOS
  end

  def install
    ENV.cxx11

    # https://github.com/protocolbuffers/protobuf/issues/9947
    ENV.append_to_cflags "-DNDEBUG"

    # teach mosh to locate mosh-client without referring
    # PATH to support launching outside shell e.g. via launcher
    inreplace "scripts/mosh.pl", "'mosh-client", "\'#{bin}/mosh-client"

    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}", "--enable-completion"
    system "make", "install"
  end

  test do
    system bin/"mosh-client", "-c"
  end
end
