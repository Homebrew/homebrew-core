class Mosh < Formula
  desc "Remote terminal application"
  homepage "https://mosh.org"
  url "https://github.com/mobile-shell/mosh/releases/download/mosh-1.4.0/mosh-1.4.0.tar.gz"
  sha256 "872e4b134e5df29c8933dff12350785054d2fd2839b5ae6b5587b14db1465ddd"
  license "GPL-3.0-or-later"
  revision 12

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "aaedb88ebb5666279ef8f9be18a0879158f85d4413e4d45902cf00eb9d90a53b"
    sha256 cellar: :any,                 arm64_ventura:  "e1c6740c1c054acdbf8c874566033f5ee46f92276bd989a7704418772b58f429"
    sha256 cellar: :any,                 arm64_monterey: "1ede495241f6adc8e386af2a2a4f204663d8a36f5197fcddf75faf3290c88b19"
    sha256 cellar: :any,                 sonoma:         "09dd7403d7b08b95ef0568e3ec3fe57ef109c6ce792861556c2c5624c8e31415"
    sha256 cellar: :any,                 ventura:        "0e0b253ad8af9c16c455af4a48ac5cea968660a2295e7dee4122404bd025c926"
    sha256 cellar: :any,                 monterey:       "bc6b4ce10a45f07a489042691e5c93c9b303be6735c37d0ff0fc3ff56532adaa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d9d80a343d644cbb30a09f903fbf6552c0c76381344b304623fc68c9d5a1aee9"
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
