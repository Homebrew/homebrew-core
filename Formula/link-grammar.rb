class LinkGrammar < Formula
  desc "Carnegie Mellon University's link grammar parser"
  homepage "https://www.abisource.com/projects/link-grammar/"
  url "https://www.abisource.com/downloads/link-grammar/5.11.0/link-grammar-5.11.0.tar.gz"
  sha256 "bdb9a359f877ff95d60f44d1780387324fa3763de5084ba1817dbf561a0ebed4"
  license "LGPL-2.1-or-later"
  head "https://github.com/opencog/link-grammar.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?link-grammar[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "af874176981d4b426f5aac09d6c227cee400ae3e42a2dcbb82d14d9c1adb2b88"
    sha256 arm64_big_sur:  "b3d69e260cf783896276b5dd4df44ec99bdbb8617835113fb964bc6aa095c135"
    sha256 monterey:       "4d1dfc85da18f9f259cf98b1768a8b61401e6406becdc8009c7ba2c34847b655"
    sha256 big_sur:        "b8e8d4df343f1748d15610eec2d14eed38bd50782d15771a9a202d18aeff629d"
    sha256 catalina:       "ac89bfaab43b5318d0a51c19963e6896a732c0f1e6c3c916a636bd45843b7ca9"
    sha256 x86_64_linux:   "335fa470f98865f3ffc91896a37230c077053ba3f347f58e87a9e5429261b8df"
  end

  depends_on "ant" => :build
  depends_on "autoconf" => :build
  depends_on "autoconf-archive" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.10" => :build

  uses_from_macos "flex" => :build
  uses_from_macos "sqlite"

  def install
    ENV["PYTHON_LIBS"] = "-undefined dynamic_lookup"
    inreplace "bindings/python/Makefile.am", "$(PYTHON_LDFLAGS) -module -no-undefined",
                                             "$(PYTHON_LDFLAGS) -module"
    system "autoreconf", "--verbose", "--install", "--force"
    system "./configure", *std_configure_args, "--with-regexlib=c"

    # Work around error due to install using detected path inside Python formula.
    # install: .../site-packages/linkgrammar.pth: Operation not permitted
    site_packages = prefix/Language::Python.site_packages("python3.10")
    system "make", "install", "pythondir=#{site_packages}",
                              "pyexecdir=#{site_packages}"
  end

  test do
    system "#{bin}/link-parser", "--version"
  end
end
