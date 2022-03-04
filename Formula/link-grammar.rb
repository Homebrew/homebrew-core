class LinkGrammar < Formula
  desc "Carnegie Mellon University's link grammar parser"
  homepage "https://www.abisource.com/projects/link-grammar/"
  url "https://www.abisource.com/downloads/link-grammar/5.10.4/link-grammar-5.10.4.tar.gz"
  sha256 "3dde2d12cadeeda193944a1eade484962b021975e1c206434ccb785046487f81"
  license "LGPL-2.1"
  head "https://github.com/opencog/link-grammar.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?link-grammar[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "9d3c2064646f6be246876ed348481b291a5869b06793e03fca87e67ecc98615f"
    sha256 arm64_big_sur:  "8ed6448e255fef875deb8c7d2cccf8f804e2cf8ee9fc57bdf0083dc02b5a4726"
    sha256 monterey:       "741e76f60e1aae9b9389704b8b74c0803b1696da2cc3272452f9f88009f6b2ec"
    sha256 big_sur:        "57353f7624c91fe0a3cc4107dd8bec7a03c2df2462d22748736fa8d06de42b01"
    sha256 catalina:       "9145c0d64b5eaf99fcb6687544362d5eafb3e64f2d1cff0746482a1088e5258b"
    sha256 x86_64_linux:   "a41e9efa99f8615254faa5f3024f236fa0fe59cc7cede0ac8d936269599b121a"
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
