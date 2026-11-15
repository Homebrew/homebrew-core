class Mosh < Formula
  desc "Remote terminal application"
  homepage "https://mosh.org"
  url "https://github.com/mobile-shell/mosh/releases/download/mosh-1.4.0/mosh-1.4.0.tar.gz"
  sha256 "872e4b134e5df29c8933dff12350785054d2fd2839b5ae6b5587b14db1465ddd"
  license "GPL-3.0-or-later"
  revision 43

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "2a6fda6cadc30f71c946cdd175d673bac2a3a66da8defd0f59eaf74738e4388c"
    sha256 cellar: :any, arm64_tahoe:       "bb486005805a4fddce729231b85fad256120c0851313a085d44843f2a6a6d3ec"
    sha256 cellar: :any, arm64_sequoia:     "b1c2a786c156c761f2073900233edc9ca87b1d246dd7323c882736aa559ff45d"
    sha256 cellar: :any, arm64_linux:       "fdcf721b9b2f4c67f4fc78d8244f3974e40bd544fe8bd1d672a2b782c64292e9"
    sha256 cellar: :any, x86_64_linux:      "1341fb3a61915fd3d68bf70cd182f243d74db62d7bd9d94dc4914a8ce686f242"
  end

  head do
    url "https://github.com/mobile-shell/mosh.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "protobuf"

  uses_from_macos "ncurses"

  on_macos do
    depends_on "tmux" => :build # for `make check`
  end

  on_linux do
    depends_on "openssl@4" # Uses CommonCrypto on macOS
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

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
    system "make", "install"
  end

  test do
    system bin/"mosh-client", "-c"
  end
end
