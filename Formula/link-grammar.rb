class LinkGrammar < Formula
  desc "Carnegie Mellon University's link grammar parser"
  homepage "https://www.abisource.com/projects/link-grammar/"
  url "https://www.abisource.com/downloads/link-grammar/5.10.2/link-grammar-5.10.2.tar.gz"
  sha256 "28cec752eaa0e3897ae961333b6927459f8b69fefe68c2aa5272983d7db869b6"
  license "LGPL-2.1"
  head "https://github.com/opencog/link-grammar.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?link-grammar[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "ec045f2765a030154e362c10d229e14a5a56ae0c771c058729d1e826e33d8a1f"
    sha256 arm64_big_sur:  "a6de3d0c3f02e8ca2347cac43ff3498785ae4e5071ee217fae3e9b52b859d571"
    sha256 monterey:       "94a6939194cb13e552a15f17272144b2fd2bf8c745ed3bf65cc50fa555e67189"
    sha256 big_sur:        "8241b4a41adb497f60591729036512f86eb11976bf3b2277d90b0c30e144d62e"
    sha256 catalina:       "024139fa467dc7c8826e092a9eb22c5f30bba6ada219cf552d60b709b77a04da"
    sha256 mojave:         "0697d8408060f2367970378d5166b311a57d8a0b6fa03eea4e9668b99dc10df4"
    sha256 x86_64_linux:   "82f640caade0e547641890ecda4967c19146366b2b071cc608b20cbc2590d18d"
  end

  depends_on "ant" => :build
  depends_on "autoconf" => :build
  depends_on "autoconf-archive" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.9" => :build

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
