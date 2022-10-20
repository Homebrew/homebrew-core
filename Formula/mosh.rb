class Mosh < Formula
  desc "Remote terminal application"
  homepage "https://mosh.org"
  license "GPL-3.0-or-later"
  revision 19

  stable do
    url "https://mosh.org/mosh-1.3.2.tar.gz"
    sha256 "da600573dfa827d88ce114e0fed30210689381bbdcff543c931e4d6a2e851216"

    # Fix mojave build.
    patch do
      url "https://github.com/mobile-shell/mosh/commit/e5f8a826ef9ff5da4cfce3bb8151f9526ec19db0.patch?full_index=1"
      sha256 "022bf82de1179b2ceb7dc6ae7b922961dfacd52fbccc30472c527cb7c87c96f0"
    end

    # Fix Xcode 12.5 build. Backport of the following commit:
    # https://github.com/mobile-shell/mosh/commit/12199114fe4234f791ef4c306163901643b40538
    patch :p0 do
      url "https://raw.githubusercontent.com/macports/macports-ports/72fb5d9a79e581a5033bce38fb00ee25a0c2fdfe/net/mosh/files/patch-version-subdir.diff"
      sha256 "939e5435ce7d9cecb7b2bccaf31294092eb131b5bd41d5776a40d660ffc95982"
    end

    # Fix crashes when mosh gets confused by timestamps. See:
    # https://github.com/mobile-shell/mosh/issues/1014
    # https://github.com/mobile-shell/mosh/pull/1124
    patch do
      url "https://github.com/mobile-shell/mosh/commit/57b97a4c910e3294b1ed441acea55da2f9ca3cb1.patch?full_index=1"
      sha256 "6557cb33d4c58476e4bc0ddb1eef417f6ac56eb62e07ee389b00d2d08e6f3171"
    end

    patch do
      url "https://github.com/mobile-shell/mosh/commit/87fd565268c5498409d81584b34467bd7e16a81f.patch?full_index=1"
      sha256 "66f8fff80fa6d7373f88abf940c1fb838d38283b87b4a8ec9bfb1bd271e47ddc"
    end
  end

  livecheck do
    url :homepage
    regex(/href=.*?mosh[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
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

  # Remove autoconf and automake when the
  # Xcode 12.5 patch is removed.
  depends_on "autoconf" => :build
  depends_on "automake" => :build
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

    # Uncomment `if build.head?` when Xcode 12.5 patch is removed
    system "./autogen.sh" # if build.head?
    system "./configure", "--prefix=#{prefix}", "--enable-completion"
    system "make", "install"
  end

  test do
    system bin/"mosh-client", "-c"
  end
end
