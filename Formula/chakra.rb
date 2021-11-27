class Chakra < Formula
  desc "Core part of the JavaScript engine that powers Microsoft Edge"
  homepage "https://github.com/chakra-core/ChakraCore"
  url "https://github.com/chakra-core/ChakraCore/archive/v1.11.24.tar.gz"
  sha256 "b99e85f2d0fa24f2b6ccf9a6d2723f3eecfe986a9d2c4d34fa1fd0d015d0595e"
  license "MIT"
  revision 2

  bottle do
    sha256 cellar: :any, big_sur:  "e89bbc179ff9477dcf8589c6b8ac1caedd528f1a4247cb66f20f5af2e3544421"
    sha256 cellar: :any, catalina: "44f4599ea428559b326091374b7d0bcbcf987496f40e513b9cd4fffba7576d37"
    sha256 cellar: :any, mojave:   "8e7489e2c043d1669446d5743352ed36ed72a94d8fc9c1bb5e2b666ab404c450"
  end

  depends_on "cmake" => :build
  depends_on "python@3.9" => :build
  depends_on "icu4c"

  uses_from_macos "llvm" => [:build, :test]

  # Currently requires Clang.
  fails_with :gcc

  # Fix build with modern compilers.
  # Remove with 1.12.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/204ce95fb69a2cd523ccb0f392b7cce4f791273a/chakra/clang10.patch"
    sha256 "5337b8d5de2e9b58f6908645d9e1deb8364d426628c415e0e37aa3288fae3de7"
  end

  # Support Python 3.
  # Remove with 1.12.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/308bb29254605f0c207ea4ed67f049fdfe5ec92c/chakra/python3.patch"
    sha256 "61c61c5376bc28ac52ec47e6d4c053eb27c04860aa4ba787a78266840ce57830"
  end

  def install
    args = %W[
      --icu=#{Formula["icu4c"].opt_include}
      -j=#{ENV.make_jobs}
      -y
    ]
    # LTO requires ld.gold, but Chakra has no way to specify to use that over regular ld.
    args << "--lto-thin" if OS.mac?

    # Build dynamically for the shared library
    system "./build.sh", *args
    # Then statically to get a usable binary
    system "./build.sh", "--static", *args

    bin.install "out/Release/ch" => "chakra"
    include.install Dir["out/Release/include/*"]
    lib.install "out/Release/#{shared_library("libChakraCore")}"
  end

  test do
    (testpath/"test.js").write("print('Hello world!');\n")
    assert_equal "Hello world!", shell_output("#{bin}/chakra test.js").chomp
  end
end
