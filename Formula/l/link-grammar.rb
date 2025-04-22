class LinkGrammar < Formula
  desc "Carnegie Mellon University's link grammar parser"
  homepage "https://github.com/opencog/link-grammar"
  url "https://github.com/opencog/link-grammar/archive/refs/tags/link-grammar-5.12.5.tar.gz"
  sha256 "04d04c6017a99f38e1cef1fee8238d2c444fffc90989951cfd64331f156d0340"
  license "LGPL-2.1-or-later"
  head "https://github.com/opencog/link-grammar.git", branch: "master"

  bottle do
    rebuild 1
    sha256 arm64_sequoia: "b26e4fb3730ac1335febb636248f4a6dcf31b76b328a49ff7404e3586d9d4a51"
    sha256 arm64_sonoma:  "5563be9ea4470cc7ae91162e1c545eb00f6ea20a942750233c4723d0a8a09bc1"
    sha256 arm64_ventura: "094dbdda6530047c3088035b5b16c9315b43c1e6252fcbcbbbb706c075dc1487"
    sha256 sonoma:        "a6ef066ddfc0d3bb883ca2b8344f2a54d293d1c418856a9e607735a0230de93f"
    sha256 ventura:       "87d8eeae3531cc7a818c7667df6856941cafa353fc71c38edcfa2c5462da7268"
    sha256 arm64_linux:   "4dce0e98628d42ff1cb3df7ac9f73a37b96c5d28f43e82cb37740ea35a527f6b"
    sha256 x86_64_linux:  "46e825822f99d43ea7eeab2751ba0e4bc36a63de3dbfed1446cb5639b5814fe1"
  end

  depends_on "ant" => :build
  depends_on "autoconf" => :build
  depends_on "autoconf-archive" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.13" => :build
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
    site_packages = prefix/Language::Python.site_packages("python3.13")
    system "make", "install", "pythondir=#{site_packages}",
                              "pyexecdir=#{site_packages}"
  end

  test do
    system bin/"link-parser", "--version"
  end
end
