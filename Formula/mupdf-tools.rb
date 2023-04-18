class MupdfTools < Formula
  desc "Lightweight PDF and XPS viewer"
  homepage "https://mupdf.com/"
  url "https://mupdf.com/downloads/archive/mupdf-1.22.0-source.tar.lz"
  sha256 "bed78a0abf8496b30c523497292de979db633eca57e02f6cd0f3c7c042551c3e"
  license "AGPL-3.0-or-later"
  head "https://git.ghostscript.com/mupdf.git", branch: "master"

  livecheck do
    formula "mupdf"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ae01ae5144245e51a7a3035dbc6dbb8cf4b857ea0cc0932866ce4e2fb95ca4b2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "98a14b8afd941d6b63abe357d8dc69d7e98cf7908da4cf30e839f39210d575cf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "10d1a79062b01f81708de3846d0aae9e14fcbedc7529326e74fff223258437cc"
    sha256 cellar: :any_skip_relocation, ventura:        "2c3c90d89f68ea0ca65eebf722cbfedd423913da962cedfbdaf4da8e71f5fa8d"
    sha256 cellar: :any_skip_relocation, monterey:       "53d05165708e68b883081c3dd9c95d6664dd5e981bcc2128621de7433cf3ad23"
    sha256 cellar: :any_skip_relocation, big_sur:        "5aad9b61ac797dc1e4fc999b62f27c7e0c615e9324afba50aa76766653f1f097"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "224d02b2f5a06a90c776871e21dc600d71cfdcb9da4adde839a831a2f8482b0e"
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
