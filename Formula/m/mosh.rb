class Mosh < Formula
  desc "Remote terminal application"
  homepage "https://mosh.org"
  url "https://github.com/mobile-shell/mosh/releases/download/mosh-1.4.0/mosh-1.4.0.tar.gz"
  sha256 "872e4b134e5df29c8933dff12350785054d2fd2839b5ae6b5587b14db1465ddd"
  license "GPL-3.0-or-later"
  revision 37

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "41afa4f3d17102b6182dc54f3a93d2affe22d0f3ae468f917a4a2984b0b11b92"
    sha256 cellar: :any,                 arm64_sequoia: "41f65942cb74318f33ed0316d8ce5a4b3823a71b7109e2539001595aeecee0f5"
    sha256 cellar: :any,                 arm64_sonoma:  "7afb27800b0342074779fb90fe7ef77d0fa7defde88db69e180ea8b220b9ff47"
    sha256 cellar: :any,                 sonoma:        "4a80ccd4d81643745eea6f56b86f976d12e576450af850144988c255a6674394"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "32b198ce224af46ee9086358f43e337f2918a51f2089e871192784a57a611c6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d97a120dcf3ecd7e841676aac364758a5f41a68254f6131f6b09a1774280d9d9"
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
    depends_on "openssl@3" # Uses CommonCrypto on macOS
    depends_on "zlib-ng-compat"
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
    system "make", "install"
  end

  test do
    system bin/"mosh-client", "-c"
  end
end
