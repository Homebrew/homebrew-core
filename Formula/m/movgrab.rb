class Movgrab < Formula
  desc "Downloader for youtube, dailymotion, and other video websites"
  homepage "https://github.com/ColumPaget/Movgrab"
  url "https://github.com/ColumPaget/Movgrab/archive/refs/tags/3.1.2.tar.gz"
  sha256 "30be6057ddbd9ac32f6e3d5456145b09526cc6bd5e3f3fb3999cc05283457529"
  license "GPL-3.0-or-later"
  revision 9

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "eebe35ad85f24d6670b44de90e944d2ec6e7d8b3d678581d765b47a37b5921de"
    sha256 cellar: :any,                 arm64_sonoma:  "8258f2373e9954cec98e1794809aceb67cb86a67b700534ca8e897399a462c1d"
    sha256 cellar: :any,                 arm64_ventura: "be7032419023759e5106d77fe86d01c97967ae01cc30947fd6e35df5d6f9b0e5"
    sha256 cellar: :any,                 sonoma:        "612d50cc540559cd4350504e7e31caa719e5f9bf1b68f6d0930328f4e56c0c17"
    sha256 cellar: :any,                 ventura:       "44d0c548daababf4c81fd834331066cbfc94ff74b50df78d8689d21d4ab0f5a2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ad5d58b74de4a42085e384ad4e090bd6f43c063119ee56dbba896653d20c1f60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "471324368d1763fdfac90349087bad2257726ba13eb462803435ed8c37a09131"
  end

  depends_on "libressl"

  uses_from_macos "zlib"

  # Fixes an incompatibility between Linux's getxattr and macOS's.
  # Reported upstream; half of this is already committed, and there's
  # a PR for the other half.
  # https://github.com/ColumPaget/libUseful/issues/1
  # https://github.com/ColumPaget/libUseful/pull/2
  patch do
    url "https://github.com/Homebrew/formula-patches/raw/936597e74d22ab8cf421bcc9c3a936cdae0f0d96/movgrab/libUseful_xattr_backport.diff"
    sha256 "d77c6661386f1a6d361c32f375b05bfdb4ac42804076922a4c0748da891367c2"
  end

  # Backport fix for GCC linker library search order
  # Upstream ref: https://github.com/ColumPaget/Movgrab/commit/fab3c87bc44d6ce47f91ded430c3512ebcf7501b
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/6e5fdfd05ce62383c7f3ac4b23ba31f5ffbac5b2/movgrab/linker.patch"
    sha256 "e23330f110cb8ea2ed29ebc99180250fa5498d53706303b4d1878dc44aa483d3"
  end

  # build patch to fix pointer conversion issues
  # upstream bug report, https://github.com/ColumPaget/Movgrab/issues/6
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/ba252015727b6f0fb362fec3edfb7c53a3f888c2/movgrab/pointer-conv.patch"
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
