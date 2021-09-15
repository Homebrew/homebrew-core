class Liblouis < Formula
  desc "Open-source braille translator and back-translator"
  homepage "http://liblouis.org"
  url "https://github.com/liblouis/liblouis/releases/download/v3.19.0/liblouis-3.19.0.tar.gz"
  sha256 "5664b8631913f432efb4419e15b3c41026984682915d0980351cb82f7ef94970"
  license all_of: ["GPL-3.0-or-later", "LGPL-2.1-or-later"]

  bottle do
    sha256 arm64_big_sur: "3a3240d45f61b595174ade34a9e8472ecc4c2819f1a31376e984f5d4318a2f94"
    sha256 big_sur:       "c6957a31908c6f4610cc6be392f0b6cf8628101582ed1752273edbe090b0ace9"
    sha256 catalina:      "e4d01bfcdd90ff82ef9040cde309340eb8bc056fc4c0d62d1b861369a96ef2c5"
    sha256 mojave:        "b1e4c7388451ee7a25862a39464888343a17a47fa09d05bfc414c0ce0ec55d1c"
    sha256 x86_64_linux:  "2a289332981f34be748be06e7463bdc62d4402e61fb7478bd68261128ccd9a7c"
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
