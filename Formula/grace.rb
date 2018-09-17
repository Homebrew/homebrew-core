class Grace < Formula
  desc "WYSIWYG 2D plotting tool for X11"
  homepage "http://plasma-gate.weizmann.ac.il/Grace/"
  url "https://mirrors.kernel.org/debian/pool/main/g/grace/grace_5.1.25.orig.tar.gz"
  sha256 "751ab9917ed0f6232073c193aba74046037e185d73b77bab0f5af3e3ff1da2ac"
  revision 2

  bottle do
    sha256 "919ed10debaca3045266712e6927d410c152ec92e44f403efc91c11a322652d4" => :mojave
    sha256 "24e9a28ea6b6665f2e8e7a0d179735a6f956bb55b02d5515570017780e4903a1" => :high_sierra
    sha256 "80eae698e6f2cf3dd8a1fb11937871f2e588417b3abfe22ff12d066dd9f0e747" => :sierra
    sha256 "f178d67cb811997af5d52c11afb1e27c73bc44a1063aa06f08bc7ee189691812" => :el_capitan
    sha256 "e1dc9c34d5417798dbd2d0c834fe099e7f1d8b395863964ffeb9fcb69e4b3c33" => :yosemite
  end

  depends_on "fftw"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "openmotif"
  depends_on "pdflib-lite"
  depends_on :x11

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
