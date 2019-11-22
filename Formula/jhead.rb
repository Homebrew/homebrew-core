class Jhead < Formula
  desc "Extract Digicam setting info from EXIF JPEG headers"
  homepage "http://www.sentex.net/~mwandel/jhead/"
  url "http://www.sentex.net/~mwandel/jhead/jhead-3.03.tar.gz"
  sha256 "82194e0128d9141038f82fadcb5845391ca3021d61bc00815078601619f6c0c2"

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
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/85fa66a9/jhead/3.00.patch"
    sha256 "743811070c31424b2a0dab3b6ced7aa3cd40bff637fb2eab295b742586873b8f"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    cp test_fixtures("test.jpg"), testpath
    system "#{bin}/jhead", "-autorot", "test.jpg"
  end
end
