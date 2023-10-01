class Mosh < Formula
  desc "Remote terminal application"
  homepage "https://mosh.org"
  url "https://github.com/mobile-shell/mosh/releases/download/mosh-1.4.0/mosh-1.4.0.tar.gz"
  sha256 "872e4b134e5df29c8933dff12350785054d2fd2839b5ae6b5587b14db1465ddd"
  license "GPL-3.0-or-later"
  revision 7

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a57a41674f05b4c46be3344975b328043f03ae2eb21d28bff3b282c78301c64a"
    sha256 cellar: :any,                 arm64_ventura:  "5385b41abbc305384440b081b8faa976235c5ebe88d168b2fcfa7272c4b5e06d"
    sha256 cellar: :any,                 arm64_monterey: "d256d62ac6e964b6379f33e548d047c47e163c9c41245c9122f620ff7d0eb1cd"
    sha256 cellar: :any,                 arm64_big_sur:  "342b208be1ec535ae078d77b0877d37b013aa6d6047f3f45cc34a7d5a8d8f417"
    sha256 cellar: :any,                 sonoma:         "7f0e73c9b7bf2a5615ea08c46f0f63897d1431a02d55cef2996212c2214119da"
    sha256 cellar: :any,                 ventura:        "92d1339cd920ced8d784e34e8dc996b21b3d696388387e409512a49e9e09d975"
    sha256 cellar: :any,                 monterey:       "fdf6330bdac536f37680c4132d5b2cad35b3267873c56b6a1008f02a14e08c3e"
    sha256 cellar: :any,                 big_sur:        "5068cdd5a5de38d0829c9d5ccf02cc8dc38df1d05e295441d455e135800d4cb9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a9342b1b96373c81b1cba4d93149a2c4383078f2db735cdcbc100cea536589d8"
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
