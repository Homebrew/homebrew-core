class MupdfTools < Formula
  desc "Lightweight PDF and XPS viewer"
  homepage "https://mupdf.com/"
  url "https://mupdf.com/downloads/archive/mupdf-1.21.1-source.tar.lz"
  sha256 "66a43490676c7f7c2ff74067328ef13285506fcc758d365ae27ea3668bd5e620"
  license "AGPL-3.0-or-later"
  head "https://git.ghostscript.com/mupdf.git", branch: "master"

  livecheck do
    formula "mupdf"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a2438ae05dcb1ef7bb9f5ebca7945f71755ab73b4574c795923becc1b686b853"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "41191fc373b044131cc1ed3b9aad1de872a1a32fd39fd56adf038ae6d2f4b7a5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d533e660ecbe75c8e8927da7a87a47465f4fb26feb1721a118a61a80fe3951b4"
    sha256 cellar: :any_skip_relocation, ventura:        "aa0894a011a39ef42fd7d9cd1b943f4187d115153cc0daa64ec6292da677dce3"
    sha256 cellar: :any_skip_relocation, monterey:       "b490fa3f2b2ef313e41a6d8d566b1b69e773692db943e897295c4a0f86d32423"
    sha256 cellar: :any_skip_relocation, big_sur:        "c87e54708bf332210409d815ec7e67d104449ae7f9fced53f5a64cf9a351984f"
    sha256 cellar: :any_skip_relocation, catalina:       "c0bc5f50252fef1e51c7cec6054d800963a4b75ad840ff49989e60f01c833b6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "08eeb40785dc9d29373080fdf29b64df4dde77abec3d9c4ef07deff64cc6003e"
  end

  conflicts_with "mupdf",
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
    system "make", "install",
           "build=release",
           "verbose=yes",
           "HAVE_X11=no",
           "HAVE_GLUT=no",
           "CC=#{ENV.cc}",
           "prefix=#{prefix}"

    # Symlink `mutool` as `mudraw` (a popular shortcut for `mutool draw`).
    bin.install_symlink bin/"mutool" => "mudraw"
    man1.install_symlink man1/"mutool.1" => "mudraw.1"
  end

  test do
    assert_match "Homebrew test", shell_output("#{bin}/mudraw -F txt #{test_fixtures("test.pdf")}")
  end
end
