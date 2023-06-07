class Mosh < Formula
  desc "Remote terminal application"
  homepage "https://mosh.org"
  url "https://github.com/mobile-shell/mosh/releases/download/mosh-1.4.0/mosh-1.4.0.tar.gz"
  sha256 "872e4b134e5df29c8933dff12350785054d2fd2839b5ae6b5587b14db1465ddd"
  license "GPL-3.0-or-later"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "0890a49f252b4b73cec2044ae2a053f7b2d7cd6119ab13f4d2abecfee13404e0"
    sha256 cellar: :any,                 arm64_monterey: "8f2b7e5b857122ccc2b1b46a1bbbf22ab4b7817f5960bde93b1681d471cf139d"
    sha256 cellar: :any,                 arm64_big_sur:  "a978b9ad4d682dd0c549af9bc031cdd4f402d64b9f22c2d327bad70d66053df8"
    sha256 cellar: :any,                 ventura:        "b679b2e9a18c82913fca23c0842c2b9e5a4bb891a372a48df5ca962fabb586e0"
    sha256 cellar: :any,                 monterey:       "df7f74721af40168ef17a55635fb345992196372f029663bedbc7dca419fa892"
    sha256 cellar: :any,                 big_sur:        "c3aa80b4edbbc1b077c78cb019d8750b2b522e9f6c3492e1b98d2b3619a364f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "58ffb22ffa582825415e33954a2375473086862b69a91e55627aaf89a019c513"
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
    # Keep C++ standard in sync with abseil.rb
    ENV.append "CXXFLAGS", "-std=c++17"

    # teach mosh to locate mosh-client without referring
    # PATH to support launching outside shell e.g. via launcher
    inreplace "scripts/mosh.pl", "'mosh-client", "'#{bin}/mosh-client"

    if build.head?
      # Prevent mosh from reporting `-dirty` in the version string.
      inreplace "Makefile.am", "--dirty", "--dirty=-Homebrew"
      system "./autogen.sh"
    end

    system "./configure", "--prefix=#{prefix}", "--enable-completion"
    system "make", "install"
  end

  test do
    system bin/"mosh-client", "-c"
  end
end
