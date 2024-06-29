class Mosh < Formula
  desc "Remote terminal application"
  homepage "https://mosh.org"
  url "https://github.com/mobile-shell/mosh/releases/download/mosh-1.4.0/mosh-1.4.0.tar.gz"
  sha256 "872e4b134e5df29c8933dff12350785054d2fd2839b5ae6b5587b14db1465ddd"
  license "GPL-3.0-or-later"
  revision 17

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "73c3ddd54913552d3a06bbb846bc7e9d334c70170c582c8cf6cbb690155d7b7a"
    sha256 cellar: :any,                 arm64_ventura:  "92300f442b7e7402e15df4fb8f5c0369a12d9754f330d0129d263c490b0a0c43"
    sha256 cellar: :any,                 arm64_monterey: "d9a0fd8b5850305ad0ef3e923035e20ec501d76dddb15c602def876056228f36"
    sha256 cellar: :any,                 sonoma:         "2037414b18e0c029778ac70498caefaefd668445cd5e1d9a7837058f95f1fea4"
    sha256 cellar: :any,                 ventura:        "bccea555cc6a04f33274301d9f3f40b22c69f8c1ced018a792ae5f7c44e28b99"
    sha256 cellar: :any,                 monterey:       "b008e88d4e143940ebe23559732b648ef7b7402154e37c94632975a0b79c3057"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a2fbc17f58f38e0429f9136d5c3a9811da4b52f0031a72da8981dbc8a9c25c1"
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
