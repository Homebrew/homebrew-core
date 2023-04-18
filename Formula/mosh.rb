class Mosh < Formula
  desc "Remote terminal application"
  homepage "https://mosh.org"
  url "https://github.com/mobile-shell/mosh/releases/download/mosh-1.4.0/mosh-1.4.0.tar.gz"
  sha256 "872e4b134e5df29c8933dff12350785054d2fd2839b5ae6b5587b14db1465ddd"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_ventura:  "1e37122ddf9eec43006108b5ebda33cbaacdf1806cb9e36f55a51e9d63127ab9"
    sha256 cellar: :any,                 arm64_monterey: "d1ee93489325ff25e04fb13721dbb9e1b6c00fee6bcd60d29bccf03175222e4b"
    sha256 cellar: :any,                 arm64_big_sur:  "570b3ac2282ed39584f61c70029d7613360e3b91f985282ccb3fc75b4a0af61b"
    sha256 cellar: :any,                 ventura:        "ab239b2556be43b941fd4e78db5fabf44531df964c0cb079351bb0e85a0a5f3e"
    sha256 cellar: :any,                 monterey:       "3cb8d2d82216e9e9c5c2f41586ccaa7d8c576031741b443213dbce184db65f79"
    sha256 cellar: :any,                 big_sur:        "ef136ae9e3ee88e154e4907753d5f3ad6d5cf2ec6102f5a13e195d4445b089e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dbae285ac8d5c5a52d2e3ef4be2ed7277e64bff69b48d37778e7401c6e930c7c"
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
    depends_on "openssl@3" # Uses CommonCrypto on macOS
  end

  def install
    ENV.cxx11

    # https://github.com/protocolbuffers/protobuf/issues/9947
    ENV.append_to_cflags "-DNDEBUG"

    # teach mosh to locate mosh-client without referring
    # PATH to support launching outside shell e.g. via launcher
    inreplace "scripts/mosh.pl", "'mosh-client", "'#{bin}/mosh-client"

    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}", "--enable-completion"
    system "make", "install"
  end

  test do
    system bin/"mosh-client", "-c"
  end
end
