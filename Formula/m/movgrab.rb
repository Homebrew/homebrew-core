class Movgrab < Formula
  desc "Downloader for youtube, dailymotion, and other video websites"
  homepage "https://github.com/ColumPaget/Movgrab"
  url "https://github.com/ColumPaget/Movgrab/archive/refs/tags/3.1.2.tar.gz"
  sha256 "30be6057ddbd9ac32f6e3d5456145b09526cc6bd5e3f3fb3999cc05283457529"
  license "GPL-3.0-or-later"
  revision 10

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "906cf4a9106e0dbdc98f73e43412b095779cb620a8ea9b4a770b3d6c0fe71cc3"
    sha256 cellar: :any,                 arm64_sequoia: "7759f5a72c8d8402841e25d3a35ef5f985ce7f41911767582179935d0bf40b0b"
    sha256 cellar: :any,                 arm64_sonoma:  "e4a8f1dc0f536a8d96f842f4b285d36ec8b5dc7526617deb623598c3a43262bf"
    sha256 cellar: :any,                 sonoma:        "9877cdc87f7efe12b097c0301614934ea999895fc2b4238564bc48730b92dc46"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5e8f4bcd11c7f2a24c9f0f4b6e8c07046643b01a516b8e11b07f3a54d653545b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3bd514f0b8349b7a15da7d9c28d64a2a8eaba6f16bdd36beb1aaa449f9b68088"
  end

  depends_on "libressl"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # Fixes an incompatibility between Linux's getxattr and macOS's.
  # Reported upstream; half of this is already committed, and there's
  # a PR for the other half.
  # https://github.com/ColumPaget/libUseful/issues/1
  # https://github.com/ColumPaget/libUseful/pull/2
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/movgrab/libUseful_xattr_backport.diff"
    sha256 "d77c6661386f1a6d361c32f375b05bfdb4ac42804076922a4c0748da891367c2"
  end

  # Backport fix for GCC linker library search order
  # Upstream ref: https://github.com/ColumPaget/Movgrab/commit/fab3c87bc44d6ce47f91ded430c3512ebcf7501b
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/movgrab/linker.patch"
    sha256 "e23330f110cb8ea2ed29ebc99180250fa5498d53706303b4d1878dc44aa483d3"
  end

  # build patch to fix pointer conversion issues
  # upstream bug report, https://github.com/ColumPaget/Movgrab/issues/6
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/movgrab/pointer-conv.patch"
    sha256 "9b5c0bb666d92c87966e610e3c2db9736371507b646359b5421f2a4fa7d68222"
  end

  def install
    # workaround for Xcode 14.3
    ENV.append "CFLAGS", "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    # Can you believe this? A forgotten semicolon! Probably got missed because it's
    # behind a conditional #ifdef.
    # Fixed upstream: https://github.com/ColumPaget/libUseful/commit/6c71f8b123fd45caf747828a9685929ab63794d7
    inreplace "libUseful-2.8/FileSystem.c", "result=-1", "result=-1;"

    # Later versions of libUseful handle the fact that setresuid is Linux-only, but
    # this one does not. https://github.com/ColumPaget/Movgrab/blob/HEAD/libUseful/Process.c#L95-L99
    inreplace "libUseful-2.8/Process.c", "setresuid(uid,uid,uid)", "setreuid(uid,uid)"

    system "./configure", "--enable-ssl", *std_configure_args
    system "make"

    # because case-insensitivity is sadly a thing and while the movgrab
    # Makefile itself doesn't declare INSTALL as a phony target, we
    # just remove the INSTALL instructions file so we can actually
    # just make install
    rm "INSTALL"
    system "make", "install"
  end

  test do
    system bin/"movgrab", "--version"
  end
end
