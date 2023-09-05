class Mosh < Formula
  desc "Remote terminal application"
  homepage "https://mosh.org"
  url "https://github.com/mobile-shell/mosh/releases/download/mosh-1.4.0/mosh-1.4.0.tar.gz"
  sha256 "872e4b134e5df29c8933dff12350785054d2fd2839b5ae6b5587b14db1465ddd"
  license "GPL-3.0-or-later"
  revision 6

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c92a411f516871d71fd86987de194516ed90fb2bdb66fd199295903b0a449f35"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1ff656d9d4d9d4776b25ebd08bb383f3d6c01f96dfaac1a8d866605cf24dbb82"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "180bbf51d1e2dd862ecb6d3f2b2a418ed83a7c49103fa6a7409ba8ab4e7c8a7d"
    sha256 cellar: :any_skip_relocation, ventura:        "532b879dbbc099c75b85755f2c400fd164261e22354403df340c3580a0f45371"
    sha256 cellar: :any_skip_relocation, monterey:       "d65ff2d91dd0b26441fceabb9f51df7389643c2433b212e808a00ee348cbe736"
    sha256 cellar: :any_skip_relocation, big_sur:        "9f3a12be720b6dd2aaa1dd27d90ec8b46efb970dd66ef86e65daf8e45ab2922e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "212673108abc31995e8347bb46299075699437f5e80e5c4724fed99a72e0ca7e"
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
