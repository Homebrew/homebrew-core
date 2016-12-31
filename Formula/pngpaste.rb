class Pngpaste < Formula
  desc "Paste PNG into files"
  homepage "https://github.com/jcsalterego/pngpaste"
  url "https://github.com/jcsalterego/pngpaste/archive/0.2.2.tar.gz"
  sha256 "f7566b4eba94916df5723cdcef8e325ee7151c530eec025e996d0e784293362c"

  bottle do
    cellar :any_skip_relocation
    sha256 "53dcb74c9ae6f97470adda82a565e70b821879dd02733aa404a8c59db49eff79" => :sierra
    sha256 "8dec6973a1c579264b4832dd6b766c5e1ce344b486bf2c302b47a299a14e6952" => :el_capitan
  end

  depends_on :macos => :el_capitan # needs NSBitmapImageFileTypePNG, etc.

  # Sierra's CLT is sufficient, but El Capitain's isn't
  depends_on :xcode => [:build, "8.0"] if MacOS.version < :sierra

  def install
    system "make", "all"
    bin.install "pngpaste"
  end

  test do
    png = test_fixtures("test.png")
    system "osascript", "-e", "set the clipboard to POSIX file (\"#{png}\")"
    system bin/"pngpaste", "test.png"
    assert File.exist? "test.png"
  end
end
