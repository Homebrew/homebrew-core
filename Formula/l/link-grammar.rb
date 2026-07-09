class LinkGrammar < Formula
  desc "Carnegie Mellon University's link grammar parser"
  homepage "https://github.com/opencog/link-grammar"
  url "https://github.com/opencog/link-grammar/archive/refs/tags/link-grammar-5.13.0.tar.gz"
  sha256 "a545b7efb7aceab2d8ad301466f199778a3da712928999ed8d66deb32ca3184f"
  license "LGPL-2.1-or-later"
  head "https://github.com/opencog/link-grammar.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "5082434ff9e6e700ef8355dbb540108970a46a576bd16adc45355d34942afe61"
    sha256 arm64_sequoia: "31cc3eed5672970a75316f8d48d903929cb384f3431493276ad8f57595c9cb35"
    sha256 arm64_sonoma:  "496da3ec09a9cd14994de8ca1e243f9246d6519df45c0cbedc43193a7a4fb13e"
    sha256 sonoma:        "547980bfce54be897fb4095e0a172523e96574d668d881dfe6788bf8783e6427"
    sha256 arm64_linux:   "33ffa53d4b71da419d2216e3d108ede83b23655ae0bddb3afab8f4f27be964b0"
    sha256 x86_64_linux:  "3c3a54388b2f5f386aa59849f1f5f6197c09a97da3b62bfaa1232eb0d820e093"
  end

  depends_on "ant" => :build
  depends_on "autoconf" => :build
  depends_on "autoconf-archive" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.14" => :build
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
    site_packages = prefix/Language::Python.site_packages("python3.14")
    system "make", "install", "pythondir=#{site_packages}",
                              "pyexecdir=#{site_packages}"
  end

  test do
    system bin/"link-parser", "--version"
  end
end
