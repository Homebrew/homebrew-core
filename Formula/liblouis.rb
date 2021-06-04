class Liblouis < Formula
  desc "Open-source braille translator and back-translator"
  homepage "http://liblouis.org"
  url "https://github.com/liblouis/liblouis/releases/download/v3.17.0/liblouis-3.17.0.tar.gz"
  sha256 "78c71476467850935d145010c8fcb26b513df1843505b3eb4c41888541a0113d"
  license all_of: ["GPL-3.0-or-later", "LGPL-2.1-or-later"]

  bottle do
    sha256 arm64_big_sur: "171919e8f3080e1d59ca4dd624d97f5cddfe4a5b984d8783c3b907cd0c2609db"
    sha256 big_sur:       "dee8bc49788989867a9f30a55f7cca529401d50741bc37f09daebbe2752ebe1c"
    sha256 catalina:      "079dcbde4ae2c34ffebf3532182fe25904bea9d68c2dc499310d39d7605ac0b1"
    sha256 mojave:        "1b7eb78e8fbad1296af70d7f5d8c405f632a1c2b0721b944965454facb7604bc"
  end

  head do
    url "https://github.com/liblouis/liblouis.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "help2man" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.9"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "check"
    system "make", "install"
    cd "python" do
      system "python3", *Language::Python.setup_install_args(prefix)
    end
    mkdir "#{prefix}/tools"
    mv "#{bin}/lou_maketable", "#{prefix}/tools/", force: true
    mv "#{bin}/lou_maketable.d", "#{prefix}/tools/", force: true
  end

  test do
    o, = Open3.capture2(bin/"lou_translate", "unicode.dis,en-us-g2.ctb", stdin_data: "42")
    assert_equal o, "⠼⠙⠃"
  end
end
