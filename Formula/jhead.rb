class Jhead < Formula
  desc "Extract Digicam setting info from EXIF JPEG headers"
  homepage "https://www.sentex.net/~mwandel/jhead/"
  url "https://www.sentex.net/~mwandel/jhead/jhead-3.04.tar.gz"
  sha256 "ef89bbcf4f6c25ed88088cf242a47a6aedfff4f08cc7dc205bf3e2c0f10a03c9"

  bottle do
    cellar :any_skip_relocation
    sha256 "449ddd95273bb9287758c6ba58aed81a2002f2eba95031027c97b615ce93ed49" => :catalina
    sha256 "1fdaa2ab0e5066688f1d3ff80821447f0957f95ba37c4c1c8d8f40b6d3a38ee9" => :mojave
    sha256 "d62f1ed9f99df061893021df1f5dc8928e52eb6ac73cfe47b41cf50bc2369f49" => :high_sierra
    sha256 "b5af56763e92712207332e51208c918b71c1b46985cb9df44eb1d8a30f59348f" => :sierra
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
