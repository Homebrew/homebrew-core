class Mosh < Formula
  desc "Remote terminal application"
  homepage "https://mosh.org"
  url "https://github.com/mobile-shell/mosh/releases/download/mosh-1.4.0/mosh-1.4.0.tar.gz"
  sha256 "872e4b134e5df29c8933dff12350785054d2fd2839b5ae6b5587b14db1465ddd"
  license "GPL-3.0-or-later"
  revision 13

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "384364cbc58dc94e33c6b32e53f2b877e1014cd635d6ba216232b45dc725a8df"
    sha256 cellar: :any,                 arm64_ventura:  "c4aab38921e8a24ff74732d7357d95a1990dd3a8d6feca447c507d6136713cf6"
    sha256 cellar: :any,                 arm64_monterey: "7fa5e6bb05486a871da58fafe04040adf9fe01f3a7ec48787f9f15da4f19cc90"
    sha256 cellar: :any,                 sonoma:         "79a666789fa858de4c5ab78ec88865cd8a6856b04b6af965a2d108f370d26551"
    sha256 cellar: :any,                 ventura:        "259c9eb8ce53f4fe6a2011f76574cd093e30b4e26556c84f83ff8cb8d41be05f"
    sha256 cellar: :any,                 monterey:       "5c5a4b69d057960f0c2b29c46a619ecd132082ea6c4ff575b89ebdb275dbacac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5c0210b2232e5ca4492baeacf3fcbc80d5c9906f8a977d6de63b4e1b0e99f007"
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
