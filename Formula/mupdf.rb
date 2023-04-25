class Mupdf < Formula
  desc "Lightweight PDF and XPS viewer"
  homepage "https://mupdf.com/"
  url "https://mupdf.com/downloads/archive/mupdf-1.22.0-source.tar.lz"
  sha256 "bed78a0abf8496b30c523497292de979db633eca57e02f6cd0f3c7c042551c3e"
  license "AGPL-3.0-or-later"
  head "https://git.ghostscript.com/mupdf.git", branch: "master"

  livecheck do
    url "https://mupdf.com/downloads/archive/"
    regex(/href=.*?mupdf[._-]v?(\d+(?:\.\d+)+)-source\.(?:t|zip)/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e962dfedc1700d4015d7ffcbc2eb6a6a99a30da03fd4eab9bc7935f4b07b8a95"
    sha256 cellar: :any,                 arm64_monterey: "484523189d84c53a8c7e87126f83e1afb26158e321c7dbe920e6095ba64f569f"
    sha256 cellar: :any,                 arm64_big_sur:  "cb3f0e143d1473876d05f86066012f5fa51ae12a1ffe175f9732d2ece7ba09b5"
    sha256 cellar: :any,                 ventura:        "26b4791b0e248cd4a1e0e78480e5c05a493e964835be5b8ae76ed55847d1611c"
    sha256 cellar: :any,                 monterey:       "cbdd7c3235ef04264268686756c33319a9ea4c21dd7ff06d340d9c3862a269d9"
    sha256 cellar: :any,                 big_sur:        "0a8e608554a200c05408056a842d420305a2f4bcc6954a8f6db9041c94f8b547"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3575e86e6db2e3ac4424e25ecde86961df0305bd19c10d7dcc01f6b0ea02ba52"
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
