class Mosh < Formula
  desc "Remote terminal application"
  homepage "https://mosh.org"
  url "https://github.com/mobile-shell/mosh/releases/download/mosh-1.4.0/mosh-1.4.0.tar.gz"
  sha256 "872e4b134e5df29c8933dff12350785054d2fd2839b5ae6b5587b14db1465ddd"
  license "GPL-3.0-or-later"
  revision 41

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "6c2e8f65805c4310480fefc9487254f94b8348983a18c92476a3867d8fc1b137"
    sha256 cellar: :any, arm64_sequoia: "f3ae0504dd900dac426724d431f50c0602c1c18234abd3585320893bb9eff25d"
    sha256 cellar: :any, arm64_sonoma:  "ed5ca54f62cb6fe3def029e61a494620d85c0554324010b056b34f97f7315eb7"
    sha256 cellar: :any, sonoma:        "b29072108c3c5da16840af485cc8d74e583b2d60c533331b352636905cd5e4ba"
    sha256 cellar: :any, arm64_linux:   "bff4f3c461511c6ecd69b634f4614096cdc65ab48f4e016fc1a25efaf5c16832"
    sha256 cellar: :any, x86_64_linux:  "887b1ba8d6c36a2f4124a5130ba88292bee5f099138c6ff11f645b97eda1ad44"
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
