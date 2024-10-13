class Movgrab < Formula
  desc "Downloader for youtube, dailymotion, and other video websites"
  homepage "https://github.com/ColumPaget/Movgrab"
  url "https://github.com/ColumPaget/Movgrab/archive/refs/tags/3.1.2.tar.gz"
  sha256 "30be6057ddbd9ac32f6e3d5456145b09526cc6bd5e3f3fb3999cc05283457529"
  license "GPL-3.0-or-later"
  revision 7

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "a58b74f845a6ae4a6900ea01ef855ba07bacf0fd24032764114c4fc18dc23bdb"
    sha256 cellar: :any,                 arm64_sonoma:   "c04859b004d24cb057ef9bec210fbe2e5959d4344ba1c0bfa0d555f48797e76f"
    sha256 cellar: :any,                 arm64_ventura:  "a1eb0df51a2bb3d1f5e689eee0c4e1d4c25f186e62e3215ddcfc6c26eee887fa"
    sha256 cellar: :any,                 arm64_monterey: "364748c6707826fda84e14d5bdbc0ce0f35a1b23a5f3338e6023b4a06b4e3897"
    sha256 cellar: :any,                 sonoma:         "c5c92bb08bb792fd166306b26154fe60e5cad236c152dbe5c7239fe1ac92f55b"
    sha256 cellar: :any,                 ventura:        "247b1e77ca8f379ccae10a44961cb89574ea3bf3dd5e75cf8ae75187df5cc5a4"
    sha256 cellar: :any,                 monterey:       "a76df40c5dd3e8ba646a55e44041b380f226c492e9e90ed03dade2794a8e51af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "61963349a8e6379b370104ac522acbb4cf912ce67a8db566f7d42a6bb50c1895"
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
