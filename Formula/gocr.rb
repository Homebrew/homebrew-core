class Gocr < Formula
  desc "Optical Character Recognition (OCR), converts images back to text"
  homepage "https://wasd.urz.uni-magdeburg.de/jschulen/ocr/"
  url "https://wasd.urz.uni-magdeburg.de/jschulen/ocr/gocr-0.52.tar.gz"
  sha256 "df906463105f5f4273becc2404570f187d4ea52bd5769d33a7a8661a747b8686"

  bottle do
    cellar :any
    sha256 "fac83eb0f14256afd06202061eece969cb5b9cd7dda66e4d20077dc823353bed" => :catalina
    sha256 "f0af1bb6614e72f70b54eeacb2063aff9eea014965611828f2e13eb8677d636b" => :mojave
    sha256 "8bcc15b6bef035a94d27a242f7cd40f6c71d4585a2b0c964f3e26aa800258f8a" => :high_sierra
    sha256 "bf3b661399dd9450b81ed3c22536ebeec0931310daa57371904ee4e40f5b0413" => :sierra
  end

  depends_on "jpeg"
  depends_on "netpbm"

  # Edit makefile to install libs per developer documentation
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/85fa66a9/gocr/0.50.patch"
    sha256 "0ed4338c3233a8d1d165f687d6cbe6eee3d393628cdf711a4f8f06b5edc7c4dc"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"

    # --mandir doesn't work correctly; fix broken Makefile
    inreplace "man/Makefile" do |s|
      s.change_make_var! "mandir", "/share/man"
    end

    system "make", "libs"
    system "make", "install"
  end

  test do
    system "#{bin}/gocr", "--help"
  end
end
