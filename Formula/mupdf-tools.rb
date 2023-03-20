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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1219731f0a89b04169b062a64af2610c9e68cf40f11080f7ead860e058baf289"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3ead325757a03e56897601e833bb3a4fa9f9c79e0f928ec0f83d952e206b9975"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ab5844c0ab99b3e304af5082a366f2c2d743a43336d3418e9acb73d7d56ca65b"
    sha256 cellar: :any_skip_relocation, ventura:        "4aad01e3ecb2c694fefc6b91178ef8c635605a931a6a2dc05ac715bf2b92e813"
    sha256 cellar: :any_skip_relocation, monterey:       "3aebfe261071bf588da0e502c6df7a54d40f1e6b64a8295fa51a04d59c007e73"
    sha256 cellar: :any_skip_relocation, big_sur:        "c87624e39175c4ec25f9a72123efc79f3caa7e4862a64081f0b6cd04d976b8db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c01b6337f44542c019493dc83f3569d49d83bb4b46aeba52c40f0b9c7ebb12b4"
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
