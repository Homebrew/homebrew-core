class LinkGrammar < Formula
  desc "Carnegie Mellon University's link grammar parser"
  homepage "https://github.com/opencog/link-grammar"
  url "https://github.com/opencog/link-grammar/archive/refs/tags/link-grammar-5.13.2.tar.gz"
  sha256 "6305b3c0d59dfbf0d0bafc715995beebf0e383a968f4cc7a665f313e69b4c059"
  license "LGPL-2.1-or-later"
  head "https://github.com/opencog/link-grammar.git", branch: "master"

  bottle do
    rebuild 1
    sha256 arm64_golden_gate: "ccf8cad221341e3a5b430063b7f9458245584419a96873e4ba7fc3a952cd98e7"
    sha256 arm64_tahoe:       "d33b0976e53138135d4f4630436298779f502f7aefc069bbc53259436ccd6626"
    sha256 arm64_sequoia:     "03f694cdcdc9d2e6ce3265e8d08e61a59333be3c915b002f193b22ae9f3da479"
    sha256 arm64_linux:       "f0d1ccffa7ff47795bcb97fba75d17757f1935621a28672a0efd126ddc478ebd"
    sha256 x86_64_linux:      "9af0e02f2077e830d742f0028c5d30702188c943e931a021b0dd5f0f8a7a2146"
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
