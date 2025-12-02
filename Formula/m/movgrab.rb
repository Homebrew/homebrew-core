class Movgrab < Formula
  desc "Downloader for youtube, dailymotion, and other video websites"
  homepage "https://github.com/ColumPaget/Movgrab"
  url "https://github.com/ColumPaget/Movgrab/archive/refs/tags/3.1.2.tar.gz"
  sha256 "30be6057ddbd9ac32f6e3d5456145b09526cc6bd5e3f3fb3999cc05283457529"
  license "GPL-3.0-or-later"
  revision 10

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "25557d01e1b440c88a1c606ec1bf4d309fb96f26b6552763c4f2133bf051bf18"
    sha256 cellar: :any,                 arm64_sequoia: "2b1dae1c56de07dab28dd97d6169709b4711e34001161d8a8daf2b7b20303e0f"
    sha256 cellar: :any,                 arm64_sonoma:  "a6616ac97c469fe1248b5bbfc4b453bad26b5d62380756c518a791026d4d454c"
    sha256 cellar: :any,                 sonoma:        "1424eb3926a2a14e9d29afbd3bbc89ee69ada326d4c9a2834c9a15e7e0bcd080"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fdab47fe3bf34b8dad1b015721cf655f190aa0dfb67ad93eeda49c0c3c0c1acb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cbcec355453382e09592b4d92ab23020bf52e6ea2a7d8c9cee74a523e50cf7d4"
  end

  depends_on "libressl"

  uses_from_macos "zlib"

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
