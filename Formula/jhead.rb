class Jhead < Formula
  desc "Extract Digicam setting info from EXIF JPEG headers"
  homepage "https://www.sentex.net/~mwandel/jhead/"
  url "https://www.sentex.net/~mwandel/jhead/jhead-3.04.tar.gz"
  sha256 "ef89bbcf4f6c25ed88088cf242a47a6aedfff4f08cc7dc205bf3e2c0f10a03c9"

  bottle do
    cellar :any_skip_relocation
    sha256 "1d7d67316306e727fd5b5df4949eb66039462a6887276130a380fa81f17453f7" => :catalina
    sha256 "bfc94a4d1c62e2df62ef63298c0ecff674a2cf5cb5d58e75b03dfa947485df6e" => :mojave
    sha256 "09cf431f5e58b7c07e0cab702c1f38c3c9ce10ca22c749e496b4947207157952" => :high_sierra
  end

  # Patch to provide a proper install target to the Makefile. The patch has
  # been submitted upstream through email. We need to carry this patch until
  # upstream decides to incorporate it.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/e37226eb9575636a728461fdc469c6706d81f564/jhead/3.04.patch"
    sha256 "2812e109fff8c0215faaa5a443d4b0aaa2b3a913aaac6b42c106903f1d62381b"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    cp test_fixtures("test.jpg"), testpath
    system "#{bin}/jhead", "-autorot", "test.jpg"
  end
end
