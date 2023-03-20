class Mupdf < Formula
  desc "Lightweight PDF and XPS viewer"
  homepage "https://mupdf.com/"
  url "https://mupdf.com/downloads/archive/mupdf-1.21.1-source.tar.lz"
  sha256 "66a43490676c7f7c2ff74067328ef13285506fcc758d365ae27ea3668bd5e620"
  license "AGPL-3.0-or-later"
  head "https://git.ghostscript.com/mupdf.git", branch: "master"

  livecheck do
    url "https://mupdf.com/downloads/archive/"
    regex(/href=.*?mupdf[._-]v?(\d+(?:\.\d+)+)-source\.(?:t|zip)/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "43e87d5790688d40265047adedbce372462b9e8419e606c610400f32f81f985e"
    sha256 cellar: :any,                 arm64_monterey: "9fefd383d0548a979b0175133f89c33c18eb5d62a37b2525f56906d5f0037026"
    sha256 cellar: :any,                 arm64_big_sur:  "bd6280d11ff9028de415e9052c9138a7cfaa2a4daa1ac5fa6faef71fae9bf502"
    sha256 cellar: :any,                 ventura:        "f88045f2d272b33038ef4fbb56930a02b8a5934c31ba1d3612a57ebbf55d6798"
    sha256 cellar: :any,                 monterey:       "128a498c8a195d0e68db7829a1b7d2af31fd1b1ed870ca283384fae5179b01f1"
    sha256 cellar: :any,                 big_sur:        "3199d10da0722cbffdaa77cd3f40049c8d0ea6a7a3be1652387d50baa5ea812c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e26e548e429d0769a77ca9b87eeb8c819e61ca1c28028cf8675a0a4832b7e9f2"
  end

  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "gumbo-parser"
  depends_on "harfbuzz"
  depends_on "jbig2dec"
  depends_on "jpeg-turbo"
  depends_on "mujs"
  depends_on "openjpeg"
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  on_linux do
    depends_on "freeglut"
    depends_on "libx11"
    depends_on "libxext"
    depends_on "mesa"
  end

  conflicts_with "mupdf-tools",
    because: "mupdf and mupdf-tools install the same binaries"

  def install
    # Temp patch suggested by Robin Watts in bug report [1].  The same patch
    # in both mupdf.rb and mupdf-tools.rb should be removed once mupdf releases
    # a version containing the proposed changes in PR [2].
    #
    # [1] https://bugs.ghostscript.com/show_bug.cgi?id=706112#c1
    # [2] https://github.com/ArtifexSoftware/mupdf/pull/32
    if OS.mac?
      inreplace "source/fitz/encode-basic.c", '#include "z-imp.h"',
                "#include \"z-imp.h\"\n#include <limits.h>"
      inreplace "source/fitz/output-ps.c", '#include "z-imp.h"',
                "#include \"z-imp.h\"\n#include <limits.h>"
    end

    # Remove bundled libraries excluding `extract` and "strongly preferred" `lcms2mt` (lcms2 fork)
    keep = %w[extract lcms2]
    (buildpath/"thirdparty").each_child { |path| path.rmtree if keep.exclude? path.basename.to_s }

    args = %W[
      build=release
      shared=yes
      verbose=yes
      prefix=#{prefix}
      CC=#{ENV.cc}
      USE_SYSTEM_LIBS=yes
      USE_SYSTEM_MUJS=yes
    ]
    # Build only runs pkg-config for libcrypto on macOS, so help find other libs
    if OS.mac?
      [
        ["FREETYPE", "freetype2"],
        ["GUMBO", "gumbo"],
        ["HARFBUZZ", "harfbuzz"],
        ["LIBJPEG", "libjpeg"],
        ["OPENJPEG", "libopenjp2"],
      ].each do |argname, libname|
        args << "SYS_#{argname}_CFLAGS=#{Utils.safe_popen_read("pkg-config", "--cflags", libname).strip}"
        args << "SYS_#{argname}_LIBS=#{Utils.safe_popen_read("pkg-config", "--libs", libname).strip}"
      end
    end
    system "make", "install", *args

    # Symlink `mutool` as `mudraw` (a popular shortcut for `mutool draw`).
    bin.install_symlink bin/"mutool" => "mudraw"
    man1.install_symlink man1/"mutool.1" => "mudraw.1"

    lib.install_symlink lib/shared_library("libmupdf") => shared_library("libmupdf-third")
  end

  test do
    assert_match "Homebrew test", shell_output("#{bin}/mudraw -F txt #{test_fixtures("test.pdf")}")
  end
end
