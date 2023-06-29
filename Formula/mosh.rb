class Mosh < Formula
  desc "Remote terminal application"
  homepage "https://mosh.org"
  url "https://github.com/mobile-shell/mosh/releases/download/mosh-1.4.0/mosh-1.4.0.tar.gz"
  sha256 "872e4b134e5df29c8933dff12350785054d2fd2839b5ae6b5587b14db1465ddd"
  license "GPL-3.0-or-later"
  revision 3

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e2f247157c264d0f83534894b1266c7acaf6736a7f3f2132726dc9c4384ea8ed"
    sha256 cellar: :any,                 arm64_monterey: "3abf9032ce37afffff482cedf00daa359db14708d68d1d33af16d3e817201179"
    sha256 cellar: :any,                 arm64_big_sur:  "eb7680f907c88a20d9d760203c77134c1dcbb4b40e54513e8b0e8c792c8ce868"
    sha256 cellar: :any,                 ventura:        "a730744c533263ba92f9a1c1688c97d7d3dba46dad0df81c46172ce7442b3cdd"
    sha256 cellar: :any,                 monterey:       "41f23e2f63ee93aee7eb98c468fa6862f4bab016ae77314a376fcdaf4fc58790"
    sha256 cellar: :any,                 big_sur:        "f8f59a70726b0866d24a4f4375c4cfb853fd0cf94863809adbe9cdd94a93d94e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb1ffef653ea318dce42179411cb913097b7ab3a59e4f87ff84642ac87ab38b2"
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
    # Keep C++ standard in sync with abseil.rb.
    # Use `gnu++17` since Mosh allows use of GNU extensions (-std=gnu++11).
    ENV.append "CXXFLAGS", "-std=gnu++17"

    # teach mosh to locate mosh-client without referring
    # PATH to support launching outside shell e.g. via launcher
    inreplace "scripts/mosh.pl", "'mosh-client", "'#{bin}/mosh-client"

    if build.head?
      # Prevent mosh from reporting `-dirty` in the version string.
      inreplace "Makefile.am", "--dirty", "--dirty=-Homebrew"
      system "./autogen.sh"
    end

    # `configure` does not recognise `--disable-debug` in `std_configure_args`.
    system "./configure", "--prefix=#{prefix}", "--enable-completion", "--disable-silent-rules"
    # We insist on a newer C++ standard than the project expects, so
    # let's run the tests to make sure we didn't break anything.
    system "make", "check" if OS.mac? # Fails on Linux.
    system "make", "install"
  end

  test do
    system bin/"mosh-client", "-c"
  end
end
