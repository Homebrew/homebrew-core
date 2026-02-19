class Ekg2 < Formula
  desc "Multiplatform, multiprotocol, plugin-based instant messenger"
  homepage "https://github.com/ekg2/ekg2"
  license "GPL-2.0-only"
  revision 4

  stable do
    url "https://src.fedoraproject.org/lookaside/extras/ekg2/ekg2-0.3.1.tar.gz/68fc05b432c34622df6561eaabef5a40/ekg2-0.3.1.tar.gz"
    mirror "https://web.archive.org/web/20161227025528/pl.ekg2.org/ekg2-0.3.1.tar.gz"
    sha256 "6ad360f8ca788d4f5baff226200f56922031ceda1ce0814e650fa4d877099c63"

    # Fix the build on OS X 10.9+
    # bugs.ekg2.org/issues/152 [LOST LINK]
    patch do
      url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/ekg2/0.3.1.patch"
      sha256 "6efbb25e57581c56fe52cf7b70dbb9c91c9217525b402f0647db820df9a14daa"
    end

    # Upstream commit, fix build against OpenSSL 1.1
    patch do
      url "https://github.com/ekg2/ekg2/commit/f05815.patch?full_index=1"
      sha256 "207639edc5e6576c8a67301c63f0b28814d9885f0d4fca5d9d9fc465f4427cd7"
    end
  end

  livecheck do
    url :homepage
    regex(/^ekg2[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 arm64_tahoe:    "a7cbb93dd8788ed190854be1563c1643bda0e79d4373f095ef76811c37f1fff7"
    sha256 arm64_sequoia:  "093e0e759abe9e253507d69e7a3008e5384ab7726caed5e008ef668d0a88703e"
    sha256 arm64_sonoma:   "dd46d5621d18a8186375e940e644acba80e3be9b4a94ac5a4d517d3b4f90dd6f"
    sha256 arm64_ventura:  "e11dd5263d14ca6151025f5d9ca8172301df336a1ec3d412617767f0c2ce7a11"
    sha256 arm64_monterey: "d233462650d03da68cc1acf4df091c2bd724cdfb124b8514161555ca731237a0"
    sha256 arm64_big_sur:  "513f5f60b4c91957d35a569665d9f55000dded765f4515e9581f291d2abfcb36"
    sha256 sonoma:         "3883db8343593cec9ba2c7d3ebbfcf05a6929c38b9fb5f3a195f5f6496f35973"
    sha256 ventura:        "cf60041384bf67e252fbe27d60baceb48ea590d22184854c1990072c3948df71"
    sha256 monterey:       "6c4d6e4a126cb31c7dda87f6080a11911ca1f153c44d26ee86ce11147f8667b3"
    sha256 big_sur:        "d5f9ac13e6ef527cf44f51bad2461976f7a0007bdbc5ded0515720793771cb57"
    sha256 arm64_linux:    "1de1e7288c6372ed38a94ebbd54b473b8d65d99ec39dbd67dab8b51be91d3b5c"
    sha256 x86_64_linux:   "b4bc5fe81b146a00416646862a5e723eae0d0c218a9373d28e9794a4f3accf16"
  end

  head do
    url "https://github.com/ekg2/ekg2.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
    depends_on "libtool" => :build
    depends_on "glib"

    on_macos do
      depends_on "gettext"
    end
  end

  # Original source tarball is gone and we use Fedora copy but they already dropped package.
  # ekg2 was also removed from other major distros like Debian/Ubuntu and Gentoo.
  # Last release on 2011-03-17 and last commit on 2019-03-15.
  deprecate! date: "2025-09-13", because: :unmaintained

  depends_on "pkgconf" => :build
  depends_on "openssl@3"
  depends_on "readline"

  def install
    # Workaround for Xcode 15
    if DevelopmentTools.clang_build_version >= 1500
      ENV.append_to_cflags "-Wno-implicit-function-declaration"
      ENV.append_to_cflags "-Wno-incompatible-function-pointer-types"
    end

    # Workaround for newer readline
    ENV.append_to_cflags "-DWANT_OBSOLETE_TYPEDEFS" if build.stable?

    args = %W[
      --enable-unicode
      --with-readline=#{Formula["readline"].opt_prefix}
      --without-gtk
      --without-libgadu
      --without-perl
      --without-python
      --without-nls
    ]
    if OS.linux?
      # Newer ncurses has opaque structures so old plugin code no longer works
      args << "--without-ncurses"
      # Help old config scripts identify arm64 linux
      args << "--build=aarch64-unknown-linux-gnu" if Hardware::CPU.arm? && Hardware::CPU.is_64_bit? && build.stable?
    end

    configure = build.head? ? "./autogen.sh" : "./configure"
    system configure, *args, *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"ekg2", "--help"
  end
end
