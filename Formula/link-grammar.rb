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
    sha256 arm64_monterey: "e70f07afcfb4943edcf572d99870e4b26378414e77837a80d9f5ad689232eec3"
    sha256 arm64_big_sur:  "367c2d72c5265279d9717928d1a11329880bbd96113d55d80926513333025db6"
    sha256 monterey:       "7c6ec2df0f6be9eb39741a3211b4926cb0822311504473c205038a229fe6574a"
    sha256 big_sur:        "67437691cb922c6bde9dfd38ff08645989abaa502898da9a7590ea2ec85d5a1d"
    sha256 catalina:       "ce09e594aebb4eccd60662f82bc40102ac7b30f600d3549a96d0f1fa38e2ec20"
    sha256 x86_64_linux:   "93a2bc42281c3a63e747f16e2685c3309be127eec556916e07ad488cb1205313"
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
