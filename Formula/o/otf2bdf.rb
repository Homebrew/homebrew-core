class Otf2bdf < Formula
  desc "OpenType to BDF font converter"
  homepage "https://github.com/jirutka/otf2bdf"
  url "https://github.com/jirutka/otf2bdf/archive/refs/tags/v3.1_p1.tar.gz"
  version "3.1_p1"
  sha256 "deb1590c249edf11dda1c7136759b59207ea0ac1c737e1c2d68dedf87c51716e"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(?:[._-]?p\d+)?)$/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5a8a13d81081f27e6115aa7096839a6db582bc96ac1aacfea9fb19607214d629"
    sha256 cellar: :any,                 arm64_sequoia: "51d176016f0bb1ef87c844b246d9f733e594314fb7fbc19f7a2a4bbae330cf6a"
    sha256 cellar: :any,                 arm64_sonoma:  "deb8ebe605b3723509213f415b25315efbc0fb1e72ad3866cabec7830b523894"
    sha256 cellar: :any,                 arm64_ventura: "a68522af5768c71394633ec7f1d347191d638fc89676d0d91f72fc4c95bb13f5"
    sha256 cellar: :any,                 sonoma:        "aa6b56b8934b71fca2d22699b41a11d6375f85afdd4325d9edf6529301796a21"
    sha256 cellar: :any,                 ventura:       "00c0aac1e143142550d43ababffa8551fdec3c31903fc08cb8ac130875a7f5b7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d0978c8ced64cd766bbbb7bfe4fbbfd1855f3f872d17628d15c5221409b01ce8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed108fc68b1333987e18c32c6ea67add776ce92b913b80e6c1a1af3af7be847b"
  end

  depends_on "freetype"

  resource "test-font" do
    on_linux do
      url "https://raw.githubusercontent.com/paddykontschak/finder/master/fonts/LucidaGrande.ttc"
      sha256 "e188b3f32f5b2d15dbf01e9b4480fed899605e287516d7c0de6809d8e7368934"
    end
  end

  def install
    chmod 0755, "mkinstalldirs"

    # `otf2bdf.c` uses `#include <ft2build.h>`, not `<freetype2/ft2build.h>`,
    # so freetype2 must be put into the search path.
    ENV.append "CFLAGS", "-I#{Formula["freetype"].opt_include}/freetype2"

    system "./configure", "--mandir=#{man}", *std_configure_args
    system "make", "install"
  end

  test do
    if OS.mac?
      assert_match "MacRoman", shell_output("#{bin}/otf2bdf -et /System/Library/Fonts/LucidaGrande.ttc")
    else
      resource("test-font").stage do
        assert_match "MacRoman", shell_output("#{bin}/otf2bdf -et LucidaGrande.ttc")
      end
    end
  end
end
