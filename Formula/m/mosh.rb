class Mosh < Formula
  desc "Remote terminal application"
  homepage "https://mosh.org"
  url "https://github.com/mobile-shell/mosh/releases/download/mosh-1.4.0/mosh-1.4.0.tar.gz"
  sha256 "872e4b134e5df29c8933dff12350785054d2fd2839b5ae6b5587b14db1465ddd"
  license "GPL-3.0-or-later"
  revision 14

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "153379d64ac0d29a5b7b158bfe377666dedc79e1825f62885e0189595a50c014"
    sha256 cellar: :any,                 arm64_ventura:  "1abb5eb5703298f896613df87618929011af09cf24e78504aef9365e63363e08"
    sha256 cellar: :any,                 arm64_monterey: "17dd344410bf603a3a43ce02fc05abf36b51102e8e5600efcf0a1b78a559d709"
    sha256 cellar: :any,                 sonoma:         "de02050dd7c07547579082c4a4f04eceaab8fd5c41ebd19aecf48f9631566192"
    sha256 cellar: :any,                 ventura:        "7e260d2917ae7fd84129cb366d3b0572199fed99d3906775aad304bb6e08d497"
    sha256 cellar: :any,                 monterey:       "9d3133a677dd298a293a1855dd16815f40e84b14f212e820b1c9ee7c493aedbb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1250d81704306853b527b2a2445c492005cb48ef684c70e1b22925d6e21ff8ee"
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
