class Mosh < Formula
  desc "Remote terminal application"
  homepage "https://mosh.org"
  license "GPL-3.0-or-later"
  revision 18

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
    sha256 cellar: :any,                 arm64_monterey: "e3a5496b74f6d67bc7076816a84ff0c9930eb8ceab3896f87aafeddda2f6929a"
    sha256 cellar: :any,                 arm64_big_sur:  "8e44cdac777141ab536453dd0ad8447e04667f5f430ef3aa488b265467e9e3da"
    sha256 cellar: :any,                 monterey:       "e2eee04b536a255c89b52eab59c02f86aa1e0681a423b18c5d4346d4cef2b1e3"
    sha256 cellar: :any,                 big_sur:        "5bee0e9377ff2080ba8fd98403253bd108f1978e2151c1145a4fc2eea6171dbd"
    sha256 cellar: :any,                 catalina:       "cfa559a5216d7a863d33952dda1e7058bcb2015aeb38bed5d1b9f48cd7a31d74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "55a704a28b09a60c5f7aaf2676555c171d6e162a3bc53a962391ad228173559c"
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
