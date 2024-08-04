class Mosh < Formula
  desc "Remote terminal application"
  homepage "https://mosh.org"
  url "https://github.com/mobile-shell/mosh/releases/download/mosh-1.4.0/mosh-1.4.0.tar.gz"
  sha256 "872e4b134e5df29c8933dff12350785054d2fd2839b5ae6b5587b14db1465ddd"
  license "GPL-3.0-or-later"
  revision 18

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "ab437b4b3c11be16309d77e4501e6c688c2c83512ac0386e2710d2a0c61d7eed"
    sha256 cellar: :any,                 arm64_ventura:  "bbaf8774548735c4605f996aec90041e315a55d58a349711f38e08c655ede23a"
    sha256 cellar: :any,                 arm64_monterey: "649db3de627b72c4d182c7c788c0db02e0407700e8f43cd9a98b149e5fb74d3b"
    sha256 cellar: :any,                 sonoma:         "3d09e7fffb9ae0c631bd4609547f5cd896ab348a83b1810108de962da2820a89"
    sha256 cellar: :any,                 ventura:        "3156da8c5d050888647c84ad13de1dba8e90b5f95a228ed8649a4f0be42854cd"
    sha256 cellar: :any,                 monterey:       "8ce7d15882925788642adca5da629e947769be239dfeb349e48350947a4e3bab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "226a7c5680edefdc30a9b010309cd1414994125211f87591c1bafe5b5a26271c"
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
    # Avoid over-linkage to `abseil`.
    ENV.append "LDFLAGS", "-Wl,-dead_strip_dylibs" if OS.mac?

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
