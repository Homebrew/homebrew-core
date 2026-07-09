class Mosh < Formula
  desc "Remote terminal application"
  homepage "https://mosh.org"
  url "https://github.com/mobile-shell/mosh/releases/download/mosh-1.4.0/mosh-1.4.0.tar.gz"
  sha256 "872e4b134e5df29c8933dff12350785054d2fd2839b5ae6b5587b14db1465ddd"
  license "GPL-3.0-or-later"
  revision 40

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "c81b37cf39a518c0b1e97bca97df97c5d5e3c1320ae981a5ef814c53ca3229ac"
    sha256 cellar: :any, arm64_sequoia: "d366345719c9d83df17cb55a1e110876aefd1d0afbc787a40b5b360c3ffba79c"
    sha256 cellar: :any, arm64_sonoma:  "aa7054dae929ec1f0af71d88b814051b80aa97f2893dc99d4e26dd3cefc45e5e"
    sha256 cellar: :any, sonoma:        "0b938101edf7cb093c2ee91829ecb7c2a1907d8b4fa7ea5336082bd6ad08ae48"
    sha256 cellar: :any, arm64_linux:   "6161ff24867c9dcb0b493d90f4cc0b93ee70680510958b1f0c24845c3c240772"
    sha256 cellar: :any, x86_64_linux:  "1ecc304757533a045e320cfc8fef55933576a94804a4e868b15ce786103dc049"
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
