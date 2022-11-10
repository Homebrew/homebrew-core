class LinkGrammar < Formula
  desc "Carnegie Mellon University's link grammar parser"
  homepage "https://www.abisource.com/projects/link-grammar/"
  url "https://www.abisource.com/downloads/link-grammar/5.11.0/link-grammar-5.11.0.tar.gz"
  sha256 "bdb9a359f877ff95d60f44d1780387324fa3763de5084ba1817dbf561a0ebed4"
  license "LGPL-2.1-or-later"
  head "https://github.com/opencog/link-grammar.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?link-grammar[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "8b37ba8dd0a9fa572f8b27ac599794944cbbcbf0ff9f285e626f158f4b8949da"
    sha256 arm64_monterey: "aa20af4221646a75ed55c925c9e31a40dac472ed2c1bac4a8fb47091726b86d5"
    sha256 arm64_big_sur:  "3ebd29a4f4bc6beeff416c488489e53960a3a56d28c29171d47c3815a939a192"
    sha256 monterey:       "b3803fc1c5a7f1ddb6273e059d0004fe9a93264df06f353c2f614cc99da62b93"
    sha256 big_sur:        "c97623baff37808a540fab1bc18cc813950d91efcfa35e49a288a7765d979fb2"
    sha256 catalina:       "9c1b15d2475130e51dd5db8c7862abd2758ead4df00a95112b8c16ea5392a3d6"
    sha256 x86_64_linux:   "4196be17d96f458b85b146cfaebe18bd9982f3462e99b83522ebb13cb37691e9"
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
    site_packages = prefix/Language::Python.site_packages("python3.10")
    system "make", "install", "pythondir=#{site_packages}",
                              "pyexecdir=#{site_packages}"
  end

  test do
    system "#{bin}/link-parser", "--version"
  end
end
