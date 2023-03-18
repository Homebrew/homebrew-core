class MscGenerator < Formula
  desc "Draws signalling charts from textual description"
  homepage "https://gitlab.com/msc-generator/msc-generator"
  url "https://gitlab.com/api/v4/projects/31167732/packages/generic/msc-generator/8.3.2/msc-generator-8.3.2.tar.gz"
  sha256 "f9eb8acb81a017ca8544d3397120468fd01b2e98c3734b1e3c92d0e7e6f89e55"
  license "AGPL-3.0-or-later"

  livecheck do
    url "https://gitlab.com/api/v4/projects/31167732/packages"
    strategy :json do |json|
      json.map do |item|
        next unless item["name"]&.downcase&.include?("msc-generator")

        item["version"]
      end
    end
  end

  bottle do
    sha256 arm64_ventura:  "76278d5fa2ce33e4e1f2ebcc27d1eb6fc6861f6c4dff0d888ab98d37b6720686"
    sha256 arm64_monterey: "d6c721135921bd819cea49c2f02693d357ca0218ba230a765c12284218cbdcb9"
    sha256 arm64_big_sur:  "c20c6559cb104390b8698e8cc97bf54d8c1e0d250f92c558fa6088c6fab3c8e0"
    sha256 ventura:        "216a07418371d93713f5841fdf096159f279a7d1e13005e534ecfa0c109a8fae"
    sha256 monterey:       "48cb526ca7471152b121ea2e3e9859111b5963c08b361ceea3aaea85f31425a8"
    sha256 big_sur:        "e375256edabd34d86a4539796d31ffc7fe1426c5a41b176e0a76fcd4b7f9314c"
    sha256 x86_64_linux:   "c5e7880a5dc72e8e053f3e686ec469cf1ab9a028016f1c290cc39231ef80bd9a"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "bison" => :build
  depends_on "help2man" => :build
  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "glpk"
  depends_on "graphviz"
  depends_on "sdl2"
  depends_on "tinyxml2"

  on_macos do
    depends_on "gcc"
  end

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
    if OS.mac?
      extra_args << "OBJCXX=/usr/bin/clang++"
      ENV.append_to_cflags "-DNDEBUG"
    end

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
