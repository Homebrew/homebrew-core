class Mosh < Formula
  desc "Remote terminal application"
  homepage "https://mosh.org"
  url "https://github.com/mobile-shell/mosh/releases/download/mosh-1.4.0/mosh-1.4.0.tar.gz"
  sha256 "872e4b134e5df29c8933dff12350785054d2fd2839b5ae6b5587b14db1465ddd"
  license "GPL-3.0-or-later"
  revision 22

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "33dc51bf37be8f249ba0004d5e647d689de56639bc8664a785390807c7be5164"
    sha256 cellar: :any,                 arm64_sonoma:  "fb5f8f8cca6ae74b71ff12ed06fa0cd4676858341de6e96958e98fb07ed20c1e"
    sha256 cellar: :any,                 arm64_ventura: "3287abf4aff9c41ee8e7f48a1c8f8af7e364379408893d7c8f925b680a326df4"
    sha256 cellar: :any,                 sonoma:        "8f262559a1216d94d747d9f9c5dd247e4c5ae768dff7990d5e331c47c9126d2e"
    sha256 cellar: :any,                 ventura:       "647a1fecda243e7b4ebd60b61a0097e8dfdd42b5a53c5a1a56172ca085f9e667"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b9646daefdde7e41415c15e53aba506fa51eba1afec405a3e2ae3ad8e10b95d0"
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
