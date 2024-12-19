class Mosh < Formula
  desc "Remote terminal application"
  homepage "https://mosh.org"
  url "https://github.com/mobile-shell/mosh/releases/download/mosh-1.4.0/mosh-1.4.0.tar.gz"
  sha256 "872e4b134e5df29c8933dff12350785054d2fd2839b5ae6b5587b14db1465ddd"
  license "GPL-3.0-or-later"
  revision 25

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0fcdde2bee9297d8a2dc3180068f44cbbfa5e7abc28ac795d614aeb93cc06931"
    sha256 cellar: :any,                 arm64_sonoma:  "3d0c50647e39a35aa21cd07ac4a886d0fabe4f9b271917380c7925ca5eab66f5"
    sha256 cellar: :any,                 arm64_ventura: "3c59395a0a6c868b584248d1ef400964e38c8074fb3ea4346bfb07e1caedc225"
    sha256 cellar: :any,                 sonoma:        "2bc01a5756bfd19f1756c43a9e227a23d895f20f12773dbd83d77d4ee8cff756"
    sha256 cellar: :any,                 ventura:       "8922da29aa5ebb38d72aeab96180fdae979dbe70d8ecd7f2afd8b0df8b0b7a89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e92a9c6481687386b0dae2e770dd8156ad89b6c965550b6d946145b01bfc697b"
  end

  head do
    url "https://github.com/mobile-shell/mosh.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "pkgconf" => :build
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
