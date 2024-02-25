class Mosh < Formula
  desc "Remote terminal application"
  homepage "https://mosh.org"
  url "https://github.com/mobile-shell/mosh/releases/download/mosh-1.4.0/mosh-1.4.0.tar.gz"
  sha256 "872e4b134e5df29c8933dff12350785054d2fd2839b5ae6b5587b14db1465ddd"
  license "GPL-3.0-or-later"
  revision 13

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "cd2b510adac763f44c5fb1de477d1ab1b89df7f495c655786969e3c5b9de385d"
    sha256 cellar: :any,                 arm64_ventura:  "d9dcc753f4ee0027ae17c411ab712a2d30160807c958ae9221ad37fc7349443a"
    sha256 cellar: :any,                 arm64_monterey: "e3c79cb999651b5d7bb1d0b84ac95f323e736f616fefe1ad77ec85de747e3edd"
    sha256 cellar: :any,                 sonoma:         "b2ea40dd80afe745a63de0438881ad937455f0f6c4b6de500cf8f1e80649a79d"
    sha256 cellar: :any,                 ventura:        "b801a1835498c054c18667807eea97ed6cfb1d96598a818ab705b771dc0e03d9"
    sha256 cellar: :any,                 monterey:       "75a371314f389cecc26a9341f7f08d2bd71dddd70873dbf2e55de8d9b8a0934f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a5cc3764647484e45c37cc88110d0bbb450fd666030afde7abc5149b5d6892c"
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
