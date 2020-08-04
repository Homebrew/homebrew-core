class Pngpaste < Formula
  desc "Paste PNG into files"
  homepage "https://github.com/jcsalterego/pngpaste"
  url "https://github.com/jcsalterego/pngpaste/archive/0.2.3.tar.gz"
  sha256 "6221201cb05191855f0d2707ce7f4055f6e1330de8efc09d386be2a6629f543b"
  license "BSD-2-Clause"

  bottle do
    cellar :any_skip_relocation
    sha256 "692e8f099ee7426310daa078d6bf2103b763b4549804f1775a5238acb1ead616" => :catalina
    sha256 "b67e349eaa3680c7be1746511a8a934e04320182d9396e75ca1936398d746779" => :mojave
    sha256 "eed393d2dbd516f60bdaa445df330a140853bee95cd49b0c3730345f57136676" => :high_sierra
  end

  # Sierra's CLT is sufficient, but El Capitain's isn't
  depends_on xcode: ["8.0", :build] if MacOS.version < :sierra

  depends_on macos: :el_capitan # needs NSBitmapImageFileTypePNG, etc.

  def install
    system "make", "all"
    bin.install "pngpaste"
  end

  test do
    png = test_fixtures("test.png")
    system "osascript", "-e", "set the clipboard to POSIX file (\"#{png}\")"
    system bin/"pngpaste", "test.png"
    assert_predicate testpath/"test.png", :exist?
  end
end
