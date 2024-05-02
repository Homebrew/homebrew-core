class LinkGrammar < Formula
  desc "Carnegie Mellon University's link grammar parser"
  homepage "https://github.com/opencog/link-grammar"
  url "https://github.com/opencog/link-grammar/archive/refs/tags/link-grammar-5.12.4.tar.gz"
  sha256 "dd24e4d64177c389bb023c5acb0fd3d73fb000ecce4938ebe872e3f0011d56e3"
  license "LGPL-2.1-or-later"
  head "https://github.com/opencog/link-grammar.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:   "6cc52f687c0a93359825c08a4fe83f49cb27ebb22541b13d039978c23b7d48e3"
    sha256 arm64_ventura:  "8bb6e06edb02ad11b3470d651b65027c5b17a4b012f4cfa514bf6730ff8e9ec4"
    sha256 arm64_monterey: "aaec34dc6053090e7bb933092bba47ac78b3f8d37cb9be4094d17121c75ba9c7"
    sha256 sonoma:         "1a915f34021f8e846e9c377e48604a8d2ccb3576dc6fecc5b10a50651a8bc563"
    sha256 ventura:        "acd8919a2587bf8be2877a1002f41e9eb4c16ae71821cacf24b644a4ef30cb6f"
    sha256 monterey:       "33a1909bf0510c2e91a2c616e40761d14cf8776732e10bfb8fc436219bffe4d6"
    sha256 x86_64_linux:   "46dde091e41033b3093291d6dce60e6e5ecf8e59d47180997c9d4864b27ebeb8"
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
