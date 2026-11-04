class LinkGrammar < Formula
  desc "Carnegie Mellon University's link grammar parser"
  homepage "https://github.com/opencog/link-grammar"
  url "https://github.com/opencog/link-grammar/archive/refs/tags/link-grammar-5.13.2.tar.gz"
  sha256 "6305b3c0d59dfbf0d0bafc715995beebf0e383a968f4cc7a665f313e69b4c059"
  license "LGPL-2.1-or-later"
  head "https://github.com/opencog/link-grammar.git", branch: "master"

  bottle do
    sha256 arm64_golden_gate: "df4989f8020fcf54254062dada9d39ef80ed6826afec3d8e13f4141131f79dd3"
    sha256 arm64_tahoe:       "4cac74fb29fea4f6709a1905bc4f1caa6fc24910e93bd98a9c471e5bb950f33b"
    sha256 arm64_sequoia:     "c9ff87eb8de5efef331db31ca20054748adac2bb18c690811732884293115ed0"
    sha256 arm64_linux:       "da01a52e00f81a451a10d707f1647e94daee63a698b280c4fd33f4d7cfab0384"
    sha256 x86_64_linux:      "01f361dbbeee35e05e0b72ef712fa349c2935cb29465bda6c4379baef4f9ef74"
  end

  depends_on "ant" => :build
  depends_on "autoconf" => :build
  depends_on "autoconf-archive" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.15" => :build
  depends_on "swig" => :build

  uses_from_macos "flex" => :build
  uses_from_macos "libedit"
  uses_from_macos "sqlite"

  def install
    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    ENV["PYTHON_LIBS"] = "-undefined dynamic_lookup"
    inreplace "bindings/python/Makefile.am", "$(PYTHON_LDFLAGS) -module -no-undefined",
                                             "$(PYTHON_LDFLAGS) -module"
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--with-regexlib=c", *std_configure_args

    # Work around error due to install using detected path inside Python formula.
    # install: .../site-packages/linkgrammar.pth: Operation not permitted
    site_packages = prefix/Language::Python.site_packages(python3)
    system "make", "install", "pythondir=#{site_packages}",
                              "pyexecdir=#{site_packages}"
  end

  test do
    system bin/"link-parser", "--version"
  end
end
