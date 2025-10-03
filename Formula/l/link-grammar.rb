class LinkGrammar < Formula
  desc "Carnegie Mellon University's link grammar parser"
  homepage "https://github.com/opencog/link-grammar"
  url "https://github.com/opencog/link-grammar/archive/refs/tags/link-grammar-5.12.8.tar.gz"
  sha256 "125c2a66386fc3378a1f2288341e69c879fa022aaa6866a5c9d72b1e6db0e62c"
  license "LGPL-2.1-or-later"
  head "https://github.com/opencog/link-grammar.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "6eb0ad564a474a263ae08a1a665d1a3c02ee40387f3672aea4ecfcc9eebf57fe"
    sha256 arm64_sequoia: "1b1c3954812e0aac76763fbdc127f0dfebb469607c34c442cd217cc75f438ffd"
    sha256 arm64_sonoma:  "a40491c80b26762861e987bcf7294d087d01adad9146af2efc23b9aa6fc806db"
    sha256 sonoma:        "de00f0f44d66131671157db0f4ebfcc53c7f0fbd0ffd721f1407f58d8c21b7c9"
    sha256 arm64_linux:   "03977ce68268e3602d530add892bb93efe2415a228989c696f14fd1959e077f0"
    sha256 x86_64_linux:  "60882d4efc1ec8b2077bf9bddcff78dfe622d7f22167989967c0c22cf873b5f7"
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
