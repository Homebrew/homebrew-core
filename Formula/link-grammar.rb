class LinkGrammar < Formula
  desc "Carnegie Mellon University's link grammar parser"
  homepage "https://www.abisource.com/projects/link-grammar/"
  url "https://www.abisource.com/downloads/link-grammar/5.5.1/link-grammar-5.5.1.tar.gz"
  sha256 "ce8934e3be937611e3dff4e2b61a2675380752ad6815b63336ebac917d9013f5"

  bottle do
    sha256 "550961c684c2ff78765d558024d180cdfc044ff22655f242746ca7b4987b6c2a" => :mojave
    sha256 "bff34f809816e033a10581fee1c99ca4adbedeb30968fdb466ade860584bbf3e" => :high_sierra
    sha256 "68fafbe26912384cb709f2c107fa463c8844753ec7396e94d43b5ee36dc7f42e" => :sierra
    sha256 "fc038b1a0ab421ed785705cf4bc7e9a64113c735d60a270f4f3771b755a43612" => :el_capitan
  end

  depends_on "ant" => :build
  depends_on "autoconf" => :build
  depends_on "autoconf-archive" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  def install
    ENV["PYTHON_LIBS"] = "-undefined dynamic_lookup"
    inreplace "bindings/python/Makefile.am",
      "$(PYTHON2_LDFLAGS) -module -no-undefined",
      "$(PYTHON2_LDFLAGS) -module"
    system "autoreconf", "-fiv"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/link-parser", "--version"
  end
end
