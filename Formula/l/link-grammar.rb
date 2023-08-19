class LinkGrammar < Formula
  desc "Carnegie Mellon University's link grammar parser"
  homepage "https://github.com/opencog/link-grammar"
  url "https://github.com/opencog/link-grammar/archive/refs/tags/link-grammar-5.12.3.tar.gz"
  sha256 "e0cd1b94cc9af20e5bd9a04604a714e11efe21ae5e453b639cdac050b6ac4150"
  license "LGPL-2.1-or-later"
  head "https://github.com/opencog/link-grammar.git", branch: "master"

  bottle do
    sha256 arm64_ventura:  "68780a19c3e1cdf5b93773774607a747d73b77914118cc3eb9a443bca81423e6"
    sha256 arm64_monterey: "4645310867d66555678ea8036cf34559064ab28a63bc1527a8e99645133a8a69"
    sha256 arm64_big_sur:  "627549f901d893ae19650a1b0091f5f548327a65749f7b53cd5d82e94ed5f3bf"
    sha256 ventura:        "9d719498637426049045d2ac4a1532d3fc90a63ccc9da91b0cd9c4a472db1342"
    sha256 monterey:       "a530e218f0513110ace858a69961edd3d824eb8f03a97af63bcd99467c6439eb"
    sha256 big_sur:        "ddfb36df0a1b30aae66e1b432d3b47259b2514b3859b7c5cedcd5148cce95927"
    sha256 x86_64_linux:   "48caf023fc83b14aede9e5958e30419182a5d34be5553b78bc257188af903ae6"
  end

  depends_on "ant" => :build
  depends_on "autoconf" => :build
  depends_on "autoconf-archive" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.11" => :build
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
    # Workaround for Xcode 14.3.
    ENV.append_to_cflags "-Wno-implicit-function-declaration"

    ENV["PYTHON_LIBS"] = "-undefined dynamic_lookup"
    inreplace "bindings/python/Makefile.am", "$(PYTHON_LDFLAGS) -module -no-undefined",
                                             "$(PYTHON_LDFLAGS) -module"
    system "autoreconf", "--verbose", "--install", "--force"
    system "./configure", *std_configure_args, "--with-regexlib=c"

    # Work around error due to install using detected path inside Python formula.
    # install: .../site-packages/linkgrammar.pth: Operation not permitted
    site_packages = prefix/Language::Python.site_packages("python3.11")
    system "make", "install", "pythondir=#{site_packages}",
                              "pyexecdir=#{site_packages}"
  end

  test do
    system "#{bin}/link-parser", "--version"
  end
end
