class Mosh < Formula
  desc "Remote terminal application"
  homepage "https://mosh.org"
  license "GPL-3.0-or-later"
  revision 17

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

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "03e6db8db3111780aee80b189a9d5d2f643d25830c3c8fa6f4a40a316059c4d1"
    sha256 cellar: :any,                 arm64_big_sur:  "684b5377659b4023ab1a137c237ca6555d9c1fa67631f763c2e7b920a3f6df6f"
    sha256 cellar: :any,                 monterey:       "c6bd43fd93bbde50702f3d49ee8da9fbb2b331184b45fc0f746371bd66b71341"
    sha256 cellar: :any,                 big_sur:        "40b9c79498b732720ff7d4fd31425231d14d1a5775bc859ef97d80388ab5e861"
    sha256 cellar: :any,                 catalina:       "6baffbe4b425c30de7589c32077a0d8b4f92e80b3d99a39e88403aa0aaf9a94a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "87aac40508bc86ad0298e807b4c78042c1be6b1f8251ce6ed1f8e100cf1b090d"
  end

  head do
    url "https://github.com/mobile-shell/mosh.git"

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
