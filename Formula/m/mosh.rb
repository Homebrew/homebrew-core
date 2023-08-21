class Mosh < Formula
  desc "Remote terminal application"
  homepage "https://mosh.org"
  url "https://github.com/mobile-shell/mosh/releases/download/mosh-1.4.0/mosh-1.4.0.tar.gz"
  sha256 "872e4b134e5df29c8933dff12350785054d2fd2839b5ae6b5587b14db1465ddd"
  license "GPL-3.0-or-later"
  revision 4

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "cdd2d7e3bbfe43525ebe6066f1748c1c33969e442ded18547ac767a9ae14eb17"
    sha256 cellar: :any,                 arm64_monterey: "749b88a7f9c420d0fbdca8f04149d2b4133c5e37b4b9be2e6d3efc1658867dc8"
    sha256 cellar: :any,                 arm64_big_sur:  "bd94ec171b2ff3cb6c8f64ceecdf9894ffa49dd62059cd39c31788d80f67605b"
    sha256 cellar: :any,                 ventura:        "f76c8c24a42a2ec22d4077fa5ab64ccc6587872d01f2ba5759083beb81ae84b1"
    sha256 cellar: :any,                 monterey:       "f1613e143631ecd0f20c27f0e0439117076bf3a8dc40728bc04e16f4748ddc49"
    sha256 cellar: :any,                 big_sur:        "20b801a44a511b7daba60c7f8804bfcb89b61adea449ff10081c60646ed1fb3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2cffb2c704a0df44613cb6f0db5fe9f6fafaf3459b14f07b1e700a73af156846"
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

  on_macos do
    depends_on "tmux" => :build # for `make check`
  end

  on_linux do
    depends_on "openssl@3" # Uses CommonCrypto on macOS
  end

  def install
    # https://github.com/protocolbuffers/protobuf/issues/9947
    ENV.append_to_cflags "-DNDEBUG"

    # teach mosh to locate mosh-client without referring
    # PATH to support launching outside shell e.g. via launcher
    inreplace "scripts/mosh.pl", "'mosh-client", "'#{bin}/mosh-client"

    if build.head?
      # Prevent mosh from reporting `-dirty` in the version string.
      inreplace "Makefile.am", "--dirty", "--dirty=-Homebrew"
      system "./autogen.sh"
    elsif version <= "1.4.0" # remove `elsif` block and `else` at version bump.
      # Keep C++ standard in sync with abseil.rb.
      # Use `gnu++17` since Mosh allows use of GNU extensions (-std=gnu++11).
      ENV.append "CXXFLAGS", "-std=gnu++17"
    else # Remove `else` block at version bump.
      odie "Install method needs updating!"
    end

    # `configure` does not recognise `--disable-debug` in `std_configure_args`.
    system "./configure", "--prefix=#{prefix}", "--enable-completion", "--disable-silent-rules"
    # Mosh provides remote shell access, so let's run the tests to avoid shipping an insecure build.
    system "make", "check" if OS.mac? # Fails on Linux.
    system "make", "install"
  end

  test do
    system bin/"mosh-client", "-c"
  end
end
