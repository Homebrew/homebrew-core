class Grace < Formula
  desc "WYSIWYG 2D plotting tool for X11"
  homepage "https://plasma-gate.weizmann.ac.il/Grace/"
  url "https://deb.debian.org/debian/pool/main/g/grace/grace_5.1.25.orig.tar.gz"
  sha256 "751ab9917ed0f6232073c193aba74046037e185d73b77bab0f5af3e3ff1da2ac"
  license "GPL-2.0-only"
  revision 4

  livecheck do
    url "https://deb.debian.org/debian/pool/main/g/grace/"
    regex(/href=.*?grace[._-]v?(\d+(?:\.\d+)+)\.orig\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "0513e12bd1ae9b631d576effdf09b697c94b627ed2c0aeb899b041a7c7d4ca89"
    sha256 arm64_big_sur:  "c0bf43c187029b99326babf6bab2a352a6fc0d4092a49dfedadeff8dfed01d6d"
    sha256 monterey:       "f0916c68e9915b20fd408f7cd3e9dad4c7d7dad85bf4c41dff95d270cf98a79f"
    sha256 big_sur:        "9f9d80717bbc12f00c6ea79416a95fde41491125e325561b1e1442613e3c260f"
    sha256 catalina:       "db3a1a8adad3df09d3e9a96e85c85d2f5e6cb09e4729560ca6b87e3d3ba636fc"
    sha256 x86_64_linux:   "c879b07803e10fea09ed93fc3a9d169848841502e17c16fc4de019355463526a"
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

  def install
    ENV.O1 # https://github.com/Homebrew/homebrew/issues/27840#issuecomment-38536704
    ENV.append "CFLAGS", "-Wno-implicit-function-declaration"
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--enable-grace-home=#{prefix}",
                          "--disable-pdfdrv"
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
