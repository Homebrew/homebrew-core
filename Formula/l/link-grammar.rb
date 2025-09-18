class LinkGrammar < Formula
  desc "Carnegie Mellon University's link grammar parser"
  homepage "https://github.com/opencog/link-grammar"
  url "https://github.com/opencog/link-grammar/archive/refs/tags/link-grammar-5.12.6.tar.gz"
  sha256 "7458de01fdb94b46c1f88edd9cc8d4570bef82ae1bbbc4cd4143e1b27a891b51"
  license "LGPL-2.1-or-later"
  head "https://github.com/opencog/link-grammar.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "7d05432249459ff8ad7f363108641692113d0a36765605a9edb977220ea2cc0d"
    sha256 arm64_sequoia: "2ad3a5b5743e78660ea26c94d0b8c134549096450c3a5b09437cb39f615917a2"
    sha256 arm64_sonoma:  "178343e859888db9b23afde3555329e2ed36e9824779f435e6d32140f8c64dc5"
    sha256 arm64_ventura: "52bde5770ecc932a24d2de5bf9a1c476626da331e7beab28be467203cf2da152"
    sha256 sonoma:        "7d98cbae897ffcaad0359ee5c260c98b12f284700b7246f5a45edf734bef0b1e"
    sha256 ventura:       "8282087c9238ab19f309c9d5cedf085c4afe435b7b79c711368bd802d36c43f8"
    sha256 arm64_linux:   "f19a39e6bf35361de9522341fbab303d2e355a31fc2e3a656ff6680201a94855"
    sha256 x86_64_linux:  "5340792a1700f9b4308335562f44af569d97e0c9b7a4baf6a494809c257e1039"
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
