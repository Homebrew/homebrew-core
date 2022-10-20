class MscGenerator < Formula
  desc "Draws signalling charts from textual description"
  homepage "https://gitlab.com/msc-generator/msc-generator"
  url "https://gitlab.com/api/v4/projects/31167732/packages/generic/msc-generator/8.2/msc-generator-8.2.tar.gz"
  sha256 "643efd48958f4fc20d40af56ea1be6c2d2e2c80c055b622c91971a3e1e5252ca"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 arm64_monterey: "f9746df56efcfd9b2e6084306587e9ac7ab8a05931f6c6e1a7ead4ca783506ad"
    sha256 arm64_big_sur:  "5eeea19b32e3195143c54da11acdb05b411d9efd24c0ed399a917579f82b84a5"
    sha256 monterey:       "abf0e87f36a6714637e2770205ac2f0ef05219df1dadc031960ecbdaea2f4c93"
    sha256 big_sur:        "47e891b3ed5a64789fa5060ef7640c9fe71d12a4fa57d8432302aa46f245e98a"
    sha256 catalina:       "ca52e1f668b9249096c0921e457f463adb3141e53fcddb5de7711d687b26c64b"
    sha256 x86_64_linux:   "6f86d646eb14e18be7d5a0976334415ff9fa6ce40d6ead350aecfe9f08ae9752"
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
