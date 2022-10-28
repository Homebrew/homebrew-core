class Mosh < Formula
  desc "Remote terminal application"
  homepage "https://mosh.org"
  url "https://github.com/mobile-shell/mosh/releases/download/mosh-1.4.0/mosh-1.4.0.tar.gz"
  sha256 "d93ec9b2b0a012f59c4b8d5902b8a70b45db01e32c7c1ef7e5acd84ecebbb95f"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a81658cb0f45ed810c4bf85d3ed03dede15bb4a09ae492030c66df38ed2b3275"
    sha256 cellar: :any,                 arm64_monterey: "526c339943747304ba76e84e8ecff1643cb8ebaa233a1bed18d8d3d737a276f3"
    sha256 cellar: :any,                 arm64_big_sur:  "566f4d02646d9190fb5bc3161ca3f2511cc53512aa37c994d91175acdba7493f"
    sha256 cellar: :any,                 monterey:       "5c8da1d73e2339ab2b7ce373aa572f4ebeb4a362a0b0816d99871597b4c847a2"
    sha256 cellar: :any,                 big_sur:        "06150ef84b2515247bd25021d896164a17ba8c855be6e68f3d8df107a46fd6ec"
    sha256 cellar: :any,                 catalina:       "589555a65e408e9a8889ca51454c397b0772343f2b8a79e34becc45edddd4a74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7ee94d82d4abc1cd22291511f45f8a88b872943c51d59eae62349f188ad3b245"
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

  on_linux do
    depends_on "openssl@1.1" # Uses CommonCrypto on macOS
  end

  def install
    ENV.cxx11

    # https://github.com/protocolbuffers/protobuf/issues/9947
    ENV.append_to_cflags "-DNDEBUG"

    # teach mosh to locate mosh-client without referring
    # PATH to support launching outside shell e.g. via launcher
    inreplace "scripts/mosh.pl", "'mosh-client", "\'#{bin}/mosh-client"

    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}", "--enable-completion"
    system "make", "install"
  end

  test do
    system bin/"mosh-client", "-c"
  end
end
