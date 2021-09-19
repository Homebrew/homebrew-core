class LinkGrammar < Formula
  desc "Carnegie Mellon University's link grammar parser"
  homepage "https://www.abisource.com/projects/link-grammar/"
  url "https://www.abisource.com/downloads/link-grammar/5.10.2/link-grammar-5.10.2.tar.gz"
  sha256 "28cec752eaa0e3897ae961333b6927459f8b69fefe68c2aa5272983d7db869b6"
  license "LGPL-2.1"
  head "https://github.com/opencog/link-grammar.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?link-grammar[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "93066eeefacc4e8095976cd3fc192dd4d9c9f3f6b6d24a7ad49d1de501ba92ac"
    sha256 big_sur:       "c80d1bef9073e1761f04074d636936036657c7347c12b1f313dbb16d3e3971db"
    sha256 catalina:      "dbd8dee3d34417e1be978ff916f7159ba77036c9a2af069d8dab23dc11243a38"
    sha256 mojave:        "8eb72ea314d9e6d5b99df22a0e7635eb5fa26e809010bdcaf2cd5f53ae6ebdc1"
    sha256 x86_64_linux:  "cf949ec99c89825d66a94e83b4cb183a49d172d4a73acf66ee95db8279245e7d"
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
    inreplace "bindings/python/Makefile.am", "$(PYTHON_LDFLAGS) -module -no-undefined",
                                             "$(PYTHON_LDFLAGS) -module"
    system "autoreconf", "--verbose", "--install", "--force"
    system "./configure", *std_configure_args, "--with-regexlib=c"

    # Work around error due to install using detected path inside Python formula.
    # install: .../site-packages/linkgrammar.pth: Operation not permitted
    site_packages = prefix/Language::Python.site_packages("python3")
    system "make", "install", "pythondir=#{site_packages}",
                              "pyexecdir=#{site_packages}"
  end

  test do
    system "#{bin}/link-parser", "--version"
  end
end
