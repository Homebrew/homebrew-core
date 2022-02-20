class LinkGrammar < Formula
  desc "Carnegie Mellon University's link grammar parser"
  homepage "https://www.abisource.com/projects/link-grammar/"
  url "https://www.abisource.com/downloads/link-grammar/5.10.3/link-grammar-5.10.3.tar.gz"
  sha256 "fd0a3bb5dc72097a8e3decb18091d1acd6e7fd52947b114755be0098b0f79ce0"
  license "LGPL-2.1"
  head "https://github.com/opencog/link-grammar.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?link-grammar[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_monterey: "2497cfab315f6c199b5a4d751d08354e3997b0ab7d2bf139b1f433765f26b877"
    sha256 arm64_big_sur:  "58f608417bce28f09eb9af4ecaf696ef8dc81085c41b6d41e9226026000dd79b"
    sha256 monterey:       "84b1c36c5cdfb1dbce496d3ea10c7182a6b1deb66369146088a9cf77fde7e2c4"
    sha256 big_sur:        "45fd5772d8e9438a0d4a82055bea5b32ae0cb2ded6942ae455b6ceedf4042547"
    sha256 catalina:       "690244f41acdcc0dc7821d0f3ca6d8453c82a8ba237f185bf18b3f79efa67791"
    sha256 x86_64_linux:   "d183af52518aa19ed2e0628496fb925b0c355b3310a37997b83a7f281874c5ba"
  end

  depends_on "ant" => :build
  depends_on "autoconf" => :build
  depends_on "autoconf-archive" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.10" => :build

  uses_from_macos "flex" => :build
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
