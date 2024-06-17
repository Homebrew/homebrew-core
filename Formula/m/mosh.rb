class Mosh < Formula
  desc "Remote terminal application"
  homepage "https://mosh.org"
  url "https://github.com/mobile-shell/mosh/releases/download/mosh-1.4.0/mosh-1.4.0.tar.gz"
  sha256 "872e4b134e5df29c8933dff12350785054d2fd2839b5ae6b5587b14db1465ddd"
  license "GPL-3.0-or-later"
  revision 15

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "edab277f4b8d0842ef4181a7a631d2419e2c5f979c44676d570cbbbbbf35b249"
    sha256 cellar: :any,                 arm64_ventura:  "8a7769c30b9cbb03776204f210137e51b30e9960601b4ab9dc446bda699b056f"
    sha256 cellar: :any,                 arm64_monterey: "435a869d284712f766d2889d0027e4a0f2f6863ad6d33f27b54a28794a436378"
    sha256 cellar: :any,                 sonoma:         "ef9b07031ab2ac001742366a40ea689ab3500df8e3584efb434b2646b73964c1"
    sha256 cellar: :any,                 ventura:        "90c0ead2f7be70031099c44fa3c6f710f2cc151267b669a2d93ec225465179ae"
    sha256 cellar: :any,                 monterey:       "5c85a0681e265ef54d42197c19587c0d16f6d68b7bfd0a66d07ed63e91d19ba2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "30e8f39b7f4738f55923ea4764e9e19af273dfff2f88b39e78261bd92d0c4231"
  end

  head do
    url "https://github.com/mobile-shell/mosh.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "abseil"
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
