class Pngpaste < Formula
  desc "Paste PNG into files"
  homepage "https://github.com/jcsalterego/pngpaste"
  url "https://github.com/jcsalterego/pngpaste/archive/0.2.2.tar.gz"
  sha256 "f7566b4eba94916df5723cdcef8e325ee7151c530eec025e996d0e784293362c"

  bottle do
    cellar :any_skip_relocation
    sha256 "ee42050acc521c8b38f38b4028f3634a616bc171ae320a2d0fa5a53cfc0581a3" => :catalina
    sha256 "795c9c105acb5751e01466c85703305dfa2410d24abf65eb234d1fc0d6201e34" => :mojave
    sha256 "9c215daf838e0aaa433a0672de6eef2254a917b4ce93fa15d6a85ef26daab917" => :high_sierra
    sha256 "53dcb74c9ae6f97470adda82a565e70b821879dd02733aa404a8c59db49eff79" => :sierra
    sha256 "8dec6973a1c579264b4832dd6b766c5e1ce344b486bf2c302b47a299a14e6952" => :el_capitan
  end

  # Sierra's CLT is sufficient, but El Capitain's isn't
  depends_on :xcode => ["8.0", :build] if MacOS.version < :sierra

  depends_on :macos => :el_capitan # needs NSBitmapImageFileTypePNG, etc.

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
