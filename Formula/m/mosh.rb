class Mosh < Formula
  desc "Remote terminal application"
  homepage "https://mosh.org"
  url "https://github.com/mobile-shell/mosh/releases/download/mosh-1.4.0/mosh-1.4.0.tar.gz"
  sha256 "872e4b134e5df29c8933dff12350785054d2fd2839b5ae6b5587b14db1465ddd"
  license "GPL-3.0-or-later"
  revision 8

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d7aea82f60f0933b35bab857c48e0d200e5c2bcffdb3748bc838cd45cfcf4100"
    sha256 cellar: :any,                 arm64_ventura:  "29b964018f1f0173b023abddc806fb73902e71f30d8dc8c9293334da8fa47465"
    sha256 cellar: :any,                 arm64_monterey: "aa0e43e028aae30cbf6ff37582016a8057c7185521193e15ae7ec41509e6e1eb"
    sha256 cellar: :any,                 sonoma:         "b0793b904c499756f0cb7ede18a0e0a6e3011d741f32a38554582ea88f6f8fe7"
    sha256 cellar: :any,                 ventura:        "020b3c9a05aa43829f6f8d8f65754e73c23cb59daea16e898d14bd7e346c98f2"
    sha256 cellar: :any,                 monterey:       "82a63af034edd9125b108fc6140e2d31ee8fcbefe1033999387798a0ed5d8c5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "89eb0c0de944e7f6f0d43ef0fe8d1332c9ca78779384f848e1a4e2b58dd7b17d"
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
