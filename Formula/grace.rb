class Grace < Formula
  desc "WYSIWYG 2D plotting tool for X11"
  homepage "http://plasma-gate.weizmann.ac.il/Grace/"
  url "https://mirrors.kernel.org/debian/pool/main/g/grace/grace_5.1.25.orig.tar.gz"
  sha256 "751ab9917ed0f6232073c193aba74046037e185d73b77bab0f5af3e3ff1da2ac"
  revision 2

  bottle do
    sha256 "c3a3a4047612f704f3d66b67abfd8786414bc008a593db862b01373561af9d85" => :sierra
    sha256 "27a34f15e0d9898a82556b0f5972dfef6fe3fdd7ef4d331f4e851177cb7eeed4" => :el_capitan
    sha256 "0721efb822050b87437e8ce49faa405a0bb83006453f35e9f6abce89ff4e7a7e" => :yosemite
  end

  depends_on :x11
  depends_on "pdflib-lite"
  depends_on "jpeg"
  depends_on "fftw"
  depends_on "openmotif"
  depends_on "libpng"

  def install
    ENV.O1 # https://github.com/Homebrew/homebrew/issues/27840#issuecomment-38536704
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--enable-grace-home=#{prefix}"
    system "make", "install"
    share.install "fonts", "examples"
    man1.install Dir["doc/*.1"]
    doc.install Dir["doc/*"]
  end

  test do
    system bin/"gracebat", share/"examples/test.dat"
    assert_equal "12/31/1999 23:59:59.999",
                 shell_output("#{bin}/convcal -i iso -o us 1999-12-31T23:59:59.999").chomp
  end
end
