class LinkGrammar < Formula
  desc "Carnegie Mellon University's link grammar parser"
  homepage "https://www.abisource.com/projects/link-grammar/"
  url "https://www.abisource.com/downloads/link-grammar/5.8.1/link-grammar-5.8.1.tar.gz"
  sha256 "11c4ff551fa5169257dacc575080c63b075c790edac29984a94641a0993b505b"
  license "LGPL-2.1"

  livecheck do
    url :homepage
    regex(/href=.*?link-grammar[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "18b6a922a24ebae883a013ee1127a9add635dc03ce45dfc6a72153b2ea6bb26f"
    sha256 big_sur:       "bb2c97f3f706ee56cce52d63ffb70ee72ecffffc589097ddb123be392d845f4a"
    sha256 catalina:      "5c915592973452233cfb4f1a059c06b43c9082345ff7094fc62db31d49e3168c"
    sha256 mojave:        "5055019667d8ae06fadb8481b1f563787daf26245bd0046502f1f009c1aacbdf"
  end

  depends_on "ant" => :build
  depends_on "autoconf" => :build
  depends_on "autoconf-archive" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.9" => :build

  uses_from_macos "sqlite"

  def install
    ENV["PYTHON_LIBS"] = "-undefined dynamic_lookup"
    inreplace "bindings/python/Makefile.am",
      "$(PYTHON_LDFLAGS) -module -no-undefined",
      "$(PYTHON_LDFLAGS) -module"
    system "autoreconf", "-fiv"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-regexlib=c"
    system "make", "install"
  end

  test do
    system "#{bin}/link-parser", "--version"
  end
end
