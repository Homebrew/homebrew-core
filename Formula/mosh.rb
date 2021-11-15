class Mosh < Formula
  desc "Remote terminal application"
  homepage "https://mosh.org"
  license "GPL-3.0-or-later"
  revision 16

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
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "f7111b2e7a9264c9e1c20b7b4dc652b344a92d7b03100450d6664de3534a7898"
    sha256 cellar: :any,                 arm64_big_sur:  "994d3f53c9af51c4bb759dd67de60a8bfffa5a2be1f5ffbd60477abe709b1801"
    sha256 cellar: :any,                 monterey:       "c6ab04fb7c03b401fb72e0e8805d71985ef31413a2ad540eb4c29b106fdb2528"
    sha256 cellar: :any,                 big_sur:        "b297986eb2a108d1f38c75e90e12f19953a39bda71ff75860e060f15f26f17d0"
    sha256 cellar: :any,                 catalina:       "b9f84223c2299ed1ecefcb98fa545d2a53613933280fbc45c9dec32e9d9a9902"
    sha256 cellar: :any,                 mojave:         "0201d43d7aed512afa30e241423c12b4828f193a7fe3155c173cccb55be56ce8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec64cfea75e3ef0eecdae39fafd071aac8e059cc7034f0105ad4b84f862a4778"
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
