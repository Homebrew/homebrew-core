class LinkGrammar < Formula
  desc "Carnegie Mellon University's link grammar parser"
  homepage "https://www.abisource.com/projects/link-grammar/"
  url "https://www.abisource.com/downloads/link-grammar/5.5.1/link-grammar-5.5.1.tar.gz"
  sha256 "ce8934e3be937611e3dff4e2b61a2675380752ad6815b63336ebac917d9013f5"

  bottle do
    sha256 "a3289ef82e81d36999f3c4db312627a98fd95d01ce19135ce9e63748a224f75d" => :high_sierra
    sha256 "09a09a54891582145c35b5570193481e7c84b50ba2d9ee1ca976695a42cda633" => :sierra
    sha256 "04daa313935550f697304588eaf4fc9ce291645b62f46ba0ce5dcd4db84e0c4d" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "autoconf" => :build
  depends_on "autoconf-archive" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "ant" => :build

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
