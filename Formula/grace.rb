class Grace < Formula
  desc "WYSIWYG 2D plotting tool for X11"
  homepage "https://plasma-gate.weizmann.ac.il/Grace/"
  url "https://deb.debian.org/debian/pool/main/g/grace/grace_5.1.25.orig.tar.gz"
  sha256 "751ab9917ed0f6232073c193aba74046037e185d73b77bab0f5af3e3ff1da2ac"
  license "GPL-2.0-only"
  revision 3

  livecheck do
    url "https://deb.debian.org/debian/pool/main/g/grace/"
    regex(/href=.*?grace[._-]v?(\d+(?:\.\d+)+)\.orig\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_big_sur: "ac76b67c8c85bc7ee8a1361334c2f70d6e74f45e5067eb4f0a688067e3667bc4"
    sha256 big_sur:       "d5d91b7e7c89c18d466f01ce56c6935bbbcab420b392f942700b2432bc39d01d"
    sha256 catalina:      "8bbfbfe5b8a205b29d21728d049f45d7acfbac1ca49dd2acc514321a9ce9f71a"
    sha256 mojave:        "d5f408abf27cb7470e65dd34296e647141fdadf3d7b3255d512cc38f6c228d48"
    sha256 x86_64_linux:  "e7b813126fc2bbd3e64b3947e83db5e9720fc005fe505aab6b34cca744a5617e"
  end

  depends_on "fftw"
  depends_on "jpeg"
  depends_on "libice"
  depends_on "libpng"
  depends_on "libsm"
  depends_on "libx11"
  depends_on "libxext"
  depends_on "libxmu"
  depends_on "libxp"
  depends_on "libxpm"
  depends_on "libxt"
  depends_on "openmotif"
  # pdflib-lite is not essential and does not currently support Apple Silicon
  depends_on "pdflib-lite" if Hardware::CPU.intel?

  def install
    ENV.O1 # https://github.com/Homebrew/homebrew/issues/27840#issuecomment-38536704
    ENV.append "CFLAGS", "-Wno-implicit-function-declaration"
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
