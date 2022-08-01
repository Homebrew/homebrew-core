class MscGenerator < Formula
  desc "Draws signalling charts from textual description"
  homepage "https://gitlab.com/msc-generator/msc-generator"
  url "https://gitlab.com/api/v4/projects/31167732/packages/generic/msc-generator/8.1/msc-generator-8.1.tar.gz"
  sha256 "d5812a1d24d42e319b5caab0316ae04d2de908db0f73c84f2797f20ebdf302a6"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 arm64_monterey: "f2b4bcf403d15c2eb9a633c5610970e1ee0f157f72d46c6eb94e9ad6549b24ee"
    sha256 arm64_big_sur:  "cc7d3b74d954713b9006eeef7d401652ac5d0cdb7a2d36e048807e77895c82b7"
    sha256 monterey:       "11d6fdad7248973073f327052c79cb78b4639d11c764fab11a7013c78268a213"
    sha256 big_sur:        "990d508e3af660908e26e1eaec698386f3a2bc052eb98161ca52987df56b3d52"
    sha256 catalina:       "42d335c820707b2b9028059ac53faf9e9d8b5612a75f2aa7292eaa3387d21535"
    sha256 x86_64_linux:   "51d70c9580701ee75913e05e9c75a44d47ec1012f55734598b443e198754f6b3"
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
