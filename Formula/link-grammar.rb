class LinkGrammar < Formula
  desc "Carnegie Mellon University's link grammar parser"
  homepage "https://www.abisource.com/projects/link-grammar/"
  url "https://www.abisource.com/downloads/link-grammar/5.12.0/link-grammar-5.12.0.tar.gz"
  sha256 "3f113daca2bd3ec8c20c7f86d5ef7e56cf8f80135f903bb7569924d6d0720383"
  license "LGPL-2.1-or-later"
  head "https://github.com/opencog/link-grammar.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?link-grammar[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "bbe9aae38bbabf529620c4ac37e7204362f5d27e1b6e25767409ffba3151d9e9"
    sha256 arm64_monterey: "ddd1a9a8ea7797f90617343b3f393aa5c7efab9f31aa467be787ed4ddfb618f4"
    sha256 arm64_big_sur:  "d1dd1f44860b36e49d8173af70979d63c8bcfbec919cc3fd6a07f9aa1e90c52e"
    sha256 ventura:        "287c1feb30837e9a8fbc976d8aaa6ef303080cb9d9469a621d1437b48f82b381"
    sha256 monterey:       "1812844bdb12bc8dc5d4c36dacc9f3eba171e137b68da2dd7ce9b660389d067c"
    sha256 big_sur:        "342952810d5bd827b80b2f34a66c1ccdacf8b7ad8b1900d1273d69fe2cf25b40"
    sha256 x86_64_linux:   "3cbd843bee05f489bc89d4a410ce33e31ae2cd3845409b77c73a8837cf84294a"
  end

  depends_on "ant" => :build
  depends_on "autoconf" => :build
  depends_on "autoconf-archive" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.11" => :build

  uses_from_macos "flex" => :build
  uses_from_macos "libedit"
  uses_from_macos "sqlite"

  # Fix for fatal error: 'threads.h' file not found
  # remove in next release
  patch do
    url "https://github.com/opencog/link-grammar/commit/725de848e4ac832ba7cd876e01f3d6a67d6e578b.patch?full_index=1"
    sha256 "e167c0c5a2713b539099ea1839c31801709e3fd5c9368eae9aa3f480fa5f1f13"
  end

  def install
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
