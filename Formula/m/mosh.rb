class Mosh < Formula
  desc "Remote terminal application"
  homepage "https://mosh.org"
  url "https://github.com/mobile-shell/mosh/releases/download/mosh-1.4.0/mosh-1.4.0.tar.gz"
  sha256 "872e4b134e5df29c8933dff12350785054d2fd2839b5ae6b5587b14db1465ddd"
  license "GPL-3.0-or-later"
  revision 21

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c596f35c89a357f1a9fa483310c559fef1edb5f97895e25dc0a81a8852afc787"
    sha256 cellar: :any,                 arm64_sonoma:  "1eabf50e621c1e1041ac9549553ff471d8e3bff491c8b957ceb78574190b6e0e"
    sha256 cellar: :any,                 arm64_ventura: "69a909115fd7d76bcc9aa6e672c52eb78899d79dd87e1e04c3c19d44cbec83e5"
    sha256 cellar: :any,                 sonoma:        "76046b1ccd71862d9868337a52afc9f27b102ee9f62949895bafcc86ea49c920"
    sha256 cellar: :any,                 ventura:       "1e5e1286ff0f8f9a25c38213a26416685070d0799b74fbdfadd77cffd035a0da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0dbe4f91c9ddc5f99ce1870fc9ac6a3971108518f432760850d28ce8c30a8b3f"
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
