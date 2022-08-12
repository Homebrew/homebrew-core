class MscGenerator < Formula
  desc "Draws signalling charts from textual description"
  homepage "https://gitlab.com/msc-generator/msc-generator"
  url "https://gitlab.com/api/v4/projects/31167732/packages/generic/msc-generator/8.2/msc-generator-8.2.tar.gz"
  sha256 "643efd48958f4fc20d40af56ea1be6c2d2e2c80c055b622c91971a3e1e5252ca"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 arm64_monterey: "48eec1368f3cb38598fb8f66cd6ad63f1272d94153756edf8dd45d6069365307"
    sha256 arm64_big_sur:  "a2e7cae9c6d9cf8ac8bf2ec45aa4c8f1161b5689d37c99f87f31d6880ba9209b"
    sha256 monterey:       "e68b99c84b24850dcc71d05f79d9d6593831ce0f43afe4a24d94c8e19157cac6"
    sha256 big_sur:        "fd425110b06dc264e7b265251835899579759abef7b11feed968f195e3512808"
    sha256 catalina:       "0e4d38f4a904d6f6685f48e1800bb814a7dd6006244da36fa7ec962a76e987d6"
    sha256 x86_64_linux:   "4fc8f06dfe3df87243441234964ed11b2db4620a4510261f746b533475509e8b"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "bison" => :build
  depends_on "help2man" => :build
  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "gcc"
  depends_on "glpk"
  depends_on "graphviz"
  depends_on "sdl2"
  depends_on "tinyxml2"

  on_linux do
    depends_on "mesa"
  end

  fails_with :clang # needs std::range

  fails_with :gcc do
    version "9"
    cause "needs std::range"
  end

  def install
    # Brew uses shims to ensure that the project is built with a single compiler.
    # However, gcc cannot compile our Objective-C++ sources (clipboard.mm), while
    # clang++ cannot compile the rest of the project. As a workaround, we set gcc
    # as the main compiler, and bypass brew's compiler shim to force using clang++
    # for Objective-C++ sources. This workaround should be removed once brew supports
    # setting separate compilers for C/C++ and Objective-C/C++.
    extra_args = []
    extra_args << "OBJCXX=/usr/bin/clang++" if OS.mac?
    system "./configure", *std_configure_args, "--disable-font-checks", *extra_args
    system "make", "V=1", "-C", "src", "install"
    system "make", "-C", "doc", "msc-gen.1"
    man1.install "doc/msc-gen.1"
  end

  test do
    # Try running the program
    system "#{bin}/msc-gen", "--version"
    # Construct a simple chart and check if PNG is generated (the default output format)
    (testpath/"simple.signalling").write("a->b;")
    system "#{bin}/msc-gen", "simple.signalling"
    assert_predicate testpath/"simple.png", :exist?
    bytes = File.binread(testpath/"simple.png")
    assert_equal bytes[0..7], "\x89PNG\r\n\x1a\n".force_encoding("ASCII-8BIT")
  end
end
