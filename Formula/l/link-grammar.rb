class LinkGrammar < Formula
  desc "Carnegie Mellon University's link grammar parser"
  homepage "https://github.com/opencog/link-grammar"
  url "https://github.com/opencog/link-grammar/archive/refs/tags/link-grammar-5.12.5.tar.gz"
  sha256 "04d04c6017a99f38e1cef1fee8238d2c444fffc90989951cfd64331f156d0340"
  license "LGPL-2.1-or-later"
  head "https://github.com/opencog/link-grammar.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:   "18358c44bd3d2e2a1f9890dee6ce8e200876e22d07e7a699b19ccc4ea161bdaf"
    sha256 arm64_ventura:  "e5afe2d8e8eab8fab995baabf62cf0826d367213354f9108081484c04efef4e3"
    sha256 arm64_monterey: "9246771db1a1c670fcca1dbd16716ea91e94211e9815f87c2da453de68a13188"
    sha256 sonoma:         "70870df7a0d5f8c55e005c8ce1e07fd36aa56fd992cce23988e620611c116042"
    sha256 ventura:        "e4463f81638102c1514527f4443a82dff59a46eec880de83aac8bdc6d3f11112"
    sha256 monterey:       "217da87c271c6650225561095f571a8b4a713a0b5c03af06dbab09d9d05d99f8"
    sha256 x86_64_linux:   "75048ee666d4d971e2f7bba40f205ebdf4b6e670f74a005cc00ac6faf8e41024"
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
    system bin/"link-parser", "--version"
  end
end
