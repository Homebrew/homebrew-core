class LinkGrammar < Formula
  desc "Carnegie Mellon University's link grammar parser"
  homepage "https://github.com/opencog/link-grammar"
  url "https://github.com/opencog/link-grammar/archive/refs/tags/link-grammar-5.12.3.tar.gz"
  sha256 "e0cd1b94cc9af20e5bd9a04604a714e11efe21ae5e453b639cdac050b6ac4150"
  license "LGPL-2.1-or-later"
  head "https://github.com/opencog/link-grammar.git", branch: "master"

  bottle do
    rebuild 1
    sha256 arm64_sonoma:   "984690d6c9df434555f86e810edd3648e09241fc3745d54e2853d524ac1111c5"
    sha256 arm64_ventura:  "092fe1345bb4946aac0738abba267ba5b95e359119bbb920e122376f0c19980b"
    sha256 arm64_monterey: "b4c6e1bcc929eda6c2f942928c991ec51814c8e3b09d4c8e7e06f6f16983c467"
    sha256 sonoma:         "58a7f8eaeb7fbdfce2794c9cb6e3315c1907aae0e651a53ec986c7cddd9cda0e"
    sha256 ventura:        "82dd35020c0673860a013bd652cd77bcfc7818b59e4ae31dc62acb8a4bcb7328"
    sha256 monterey:       "632cc70a9a47502c3f71e757fae753698df4165b774eef2a0a0c89b27c8baa83"
    sha256 x86_64_linux:   "56716e1742272dbb0503f12007b3eef50c3db003be55fb4b28ca78fe2a54bb93"
  end

  depends_on "ant" => :build
  depends_on "autoconf" => :build
  depends_on "autoconf-archive" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.12" => :build
  depends_on "swig" => :build

  uses_from_macos "flex" => :build
  uses_from_macos "libedit"
  uses_from_macos "sqlite"

  # upstream build patch ref, https://github.com/opencog/link-grammar/pull/1473
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/6de1efe/link-grammar/5.12.3.patch"
    sha256 "20d2c503ee2b50198d09ce5b69e39b4b88d9e8df849621e7b9f493f45c78ed1d"
  end

  def install
    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    ENV["PYTHON_LIBS"] = "-undefined dynamic_lookup"
    inreplace "bindings/python/Makefile.am", "$(PYTHON_LDFLAGS) -module -no-undefined",
                                             "$(PYTHON_LDFLAGS) -module"
    system "autoreconf", "--verbose", "--install", "--force"
    system "./configure", *std_configure_args, "--with-regexlib=c"

    # Work around error due to install using detected path inside Python formula.
    # install: .../site-packages/linkgrammar.pth: Operation not permitted
    site_packages = prefix/Language::Python.site_packages("python3.12")
    system "make", "install", "pythondir=#{site_packages}",
                              "pyexecdir=#{site_packages}"
  end

  test do
    system "#{bin}/link-parser", "--version"
  end
end
