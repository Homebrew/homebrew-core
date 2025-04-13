class Mosh < Formula
  desc "Remote terminal application"
  homepage "https://mosh.org"
  url "https://github.com/mobile-shell/mosh/releases/download/mosh-1.4.0/mosh-1.4.0.tar.gz"
  sha256 "872e4b134e5df29c8933dff12350785054d2fd2839b5ae6b5587b14db1465ddd"
  license "GPL-3.0-or-later"
  revision 26

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "332e33cd2cc6b612830b92757cd74fa5371b24518d0cdca5c41da9f342c0fc81"
    sha256 cellar: :any,                 arm64_sonoma:  "be86e68fe178fd4ec4997f320875438df088428f70e38f640a2c56ae5574d6c6"
    sha256 cellar: :any,                 arm64_ventura: "c5eb7da2878edc09a82d6f30087bf0b025d2f1ac03a1de4a564bcc5d9d7ae24b"
    sha256 cellar: :any,                 sonoma:        "d5ba6c67df6d29aa90f5596c9ae613d237e0c448e2ac78f5ee7868d65f7dc748"
    sha256 cellar: :any,                 ventura:       "9a89c7a0008af27915b35b6e1fd8938ef2e7899484f2d19027836bd630f7f997"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "37c7642af2e149bf8c7a26c72431c8fbe96775bda22d53cd2f2a747cf4f429b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5a8ac06965b89d7cab36d8b3526d781efb09420c9cf6bee7f74b75e740dd93c3"
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
